import { prisma } from './prisma';
import { MembershipType } from '@prisma/client';

async function main() {
  console.log('Starting database seeding...');

  // Clear existing data
  await prisma.attendance.deleteMany();
  await prisma.dayPass.deleteMany();
  await prisma.membership.deleteMany();
  await prisma.member.deleteMany();

  // Create new members
  const members = await Promise.all([
    prisma.member.create({
      data: {
        dni: '12345678',
        firstName: 'Juan',
        lastName: 'Pérez',
        email: 'juan.perez@email.com',
        phone: '+51987654321',
      },
    }),
    prisma.member.create({
      data: {
        dni: '87654321',
        firstName: 'María',
        lastName: 'García',
        email: 'maria.garcia@email.com',
        phone: '+51912345678',
      },
    }),
    prisma.member.create({
      data: {
        dni: '11223344',
        firstName: 'Carlos',
        lastName: 'López',
        email: 'carlos.lopez@email.com',
        phone: '+51998877665',
      },
    }),
    prisma.member.create({
      data: {
        dni: '55667788',
        firstName: 'Ana',
        lastName: 'Martínez',
        email: 'ana.martinez@email.com',
        phone: '+51944332211',
      },
    }),
  ]);

  console.log(`Created ${members.length} members`);

  // Create new memberships
  const now = new Date();

  const memberships = await Promise.all([
    // Membresía activa de 12 meses para Juan
    prisma.membership.create({
      data: {
        memberId: members[0].id,
        type: MembershipType.TWELVE_MONTHS,
        startDate: new Date(now.getFullYear(), now.getMonth() - 2, 1),
        endDate: new Date(now.getFullYear() + 1, now.getMonth() - 2, 1),
        price: 600.0,
        isActive: true,
      },
    }),
    // Membresía que vence pronto para María
    prisma.membership.create({
      data: {
        memberId: members[1].id,
        type: MembershipType.SIX_MONTHS,
        startDate: new Date(now.getFullYear(), now.getMonth() - 5, 15),
        endDate: new Date(now.getFullYear(), now.getMonth() + 1, 15),
        price: 350.0,
        isActive: true,
      },
    }),
    // Membresía activa de 3 meses para Carlos
    prisma.membership.create({
      data: {
        memberId: members[2].id,
        type: MembershipType.THREE_MONTHS,
        startDate: new Date(now.getFullYear(), now.getMonth() - 1, 10),
        endDate: new Date(now.getFullYear(), now.getMonth() + 2, 10),
        price: 180.0,
        isActive: true,
      },
    }),
    // Membresía expirada para Ana
    prisma.membership.create({
      data: {
        memberId: members[3].id,
        type: MembershipType.THREE_MONTHS,
        startDate: new Date(now.getFullYear(), now.getMonth() - 4, 5),
        endDate: new Date(now.getFullYear(), now.getMonth() - 1, 5),
        price: 180.0,
        isActive: false,
      },
    }),
  ]);

  console.log(`Created ${memberships.length} memberships`);

  // Create some day passes
  const dayPasses = await Promise.all([
    prisma.dayPass.create({
      data: {
        name: 'Pedro Rodríguez',
        dni: '99887766',
        price: 15.0,
        date: new Date(now.getFullYear(), now.getMonth(), now.getDate() - 2),
      },
    }),
    prisma.dayPass.create({
      data: {
        name: 'Lucía Fernández',
        dni: '44556677',
        price: 15.0,
        date: new Date(now.getFullYear(), now.getMonth(), now.getDate() - 1),
      },
    }),
  ]);

  console.log(`Created ${dayPasses.length} day passes`);

  // Create some attendance records
  const attendances = await Promise.all([
    // Asistencias de miembros
    prisma.attendance.create({
      data: {
        memberId: members[0].id,
        timestamp: new Date(
          now.getFullYear(),
          now.getMonth(),
          now.getDate(),
          8,
          30
        ),
      },
    }),
    prisma.attendance.create({
      data: {
        memberId: members[1].id,
        timestamp: new Date(
          now.getFullYear(),
          now.getMonth(),
          now.getDate(),
          9,
          15
        ),
      },
    }),
    prisma.attendance.create({
      data: {
        memberId: members[2].id,
        timestamp: new Date(
          now.getFullYear(),
          now.getMonth(),
          now.getDate(),
          18,
          45
        ),
      },
    }),
    // Asistencias de day passes
    prisma.attendance.create({
      data: {
        dayPassId: dayPasses[0].id,
        timestamp: new Date(
          now.getFullYear(),
          now.getMonth(),
          now.getDate() - 2,
          10,
          0
        ),
      },
    }),
    prisma.attendance.create({
      data: {
        dayPassId: dayPasses[1].id,
        timestamp: new Date(
          now.getFullYear(),
          now.getMonth(),
          now.getDate() - 1,
          14,
          30
        ),
      },
    }),
  ]);

  console.log(`Created ${attendances.length} attendance records`);

  console.log('Database seeding completed successfully!');
}

main()
  .catch((e) => {
    console.error('Error during seeding:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
    console.log('Database connection closed');
  });
