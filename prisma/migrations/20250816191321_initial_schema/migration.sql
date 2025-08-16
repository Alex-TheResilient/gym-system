-- CreateEnum
CREATE TYPE "public"."MembershipType" AS ENUM ('THREE_MONTHS', 'SIX_MONTHS', 'TWELVE_MONTHS');

-- CreateTable
CREATE TABLE "public"."Member" (
    "id" TEXT NOT NULL,
    "dni" TEXT NOT NULL,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "email" TEXT,
    "phone" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Member_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Membership" (
    "id" TEXT NOT NULL,
    "memberId" TEXT NOT NULL,
    "type" "public"."MembershipType" NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3) NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Membership_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."DayPass" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "dni" TEXT NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "DayPass_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Attendance" (
    "id" TEXT NOT NULL,
    "memberId" TEXT,
    "dayPassId" TEXT,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Attendance_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Member_dni_key" ON "public"."Member"("dni");

-- CreateIndex
CREATE INDEX "Membership_memberId_isActive_idx" ON "public"."Membership"("memberId", "isActive");

-- CreateIndex
CREATE INDEX "Membership_endDate_idx" ON "public"."Membership"("endDate");

-- CreateIndex
CREATE INDEX "DayPass_dni_date_idx" ON "public"."DayPass"("dni", "date");

-- CreateIndex
CREATE INDEX "DayPass_date_idx" ON "public"."DayPass"("date");

-- CreateIndex
CREATE INDEX "Attendance_memberId_timestamp_idx" ON "public"."Attendance"("memberId", "timestamp");

-- CreateIndex
CREATE INDEX "Attendance_dayPassId_timestamp_idx" ON "public"."Attendance"("dayPassId", "timestamp");

-- CreateIndex
CREATE INDEX "Attendance_timestamp_idx" ON "public"."Attendance"("timestamp");

-- AddForeignKey
ALTER TABLE "public"."Membership" ADD CONSTRAINT "Membership_memberId_fkey" FOREIGN KEY ("memberId") REFERENCES "public"."Member"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Attendance" ADD CONSTRAINT "Attendance_memberId_fkey" FOREIGN KEY ("memberId") REFERENCES "public"."Member"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Attendance" ADD CONSTRAINT "Attendance_dayPassId_fkey" FOREIGN KEY ("dayPassId") REFERENCES "public"."DayPass"("id") ON DELETE SET NULL ON UPDATE CASCADE;
