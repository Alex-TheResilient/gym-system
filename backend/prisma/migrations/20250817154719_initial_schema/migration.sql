-- CreateEnum
CREATE TYPE "public"."MembershipType" AS ENUM ('THREE_MONTHS', 'SIX_MONTHS', 'TWELVE_MONTHS');

-- CreateTable
CREATE TABLE "public"."members" (
    "id" TEXT NOT NULL,
    "dni" TEXT NOT NULL,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "email" TEXT,
    "phone" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "members_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."memberships" (
    "id" TEXT NOT NULL,
    "memberId" TEXT NOT NULL,
    "type" "public"."MembershipType" NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3) NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "memberships_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."day_passes" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "dni" TEXT NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "day_passes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."attendances" (
    "id" TEXT NOT NULL,
    "memberId" TEXT,
    "dayPassId" TEXT,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "attendances_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "members_dni_key" ON "public"."members"("dni");

-- CreateIndex
CREATE INDEX "memberships_memberId_isActive_idx" ON "public"."memberships"("memberId", "isActive");

-- CreateIndex
CREATE INDEX "memberships_endDate_idx" ON "public"."memberships"("endDate");

-- CreateIndex
CREATE INDEX "day_passes_dni_date_idx" ON "public"."day_passes"("dni", "date");

-- CreateIndex
CREATE INDEX "day_passes_date_idx" ON "public"."day_passes"("date");

-- CreateIndex
CREATE INDEX "attendances_memberId_timestamp_idx" ON "public"."attendances"("memberId", "timestamp");

-- CreateIndex
CREATE INDEX "attendances_dayPassId_timestamp_idx" ON "public"."attendances"("dayPassId", "timestamp");

-- CreateIndex
CREATE INDEX "attendances_timestamp_idx" ON "public"."attendances"("timestamp");

-- AddForeignKey
ALTER TABLE "public"."memberships" ADD CONSTRAINT "memberships_memberId_fkey" FOREIGN KEY ("memberId") REFERENCES "public"."members"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."attendances" ADD CONSTRAINT "attendances_memberId_fkey" FOREIGN KEY ("memberId") REFERENCES "public"."members"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."attendances" ADD CONSTRAINT "attendances_dayPassId_fkey" FOREIGN KEY ("dayPassId") REFERENCES "public"."day_passes"("id") ON DELETE SET NULL ON UPDATE CASCADE;
