-- Add inside a Prisma migration (prisma migrate dev --create-only, then paste).
-- Prisma cannot express these, PostgreSQL enforces them even under concurrent requests.

CREATE EXTENSION IF NOT EXISTS btree_gist;

-- A car can never have two active bookings with overlapping dates.
-- This is what makes "no race conditions" (mandatory multi-user rule) provable.
ALTER TABLE "Booking"
  ADD CONSTRAINT booking_no_overlap
  EXCLUDE USING gist (
    "carId" WITH =,
    daterange("startDate", "endDate", '[]') WITH &&
  ) WHERE ("status" IN ('PENDING', 'CONFIRMED', 'ACTIVE'));

ALTER TABLE "Booking" ADD CONSTRAINT booking_dates_valid CHECK ("endDate" >= "startDate");
ALTER TABLE "Review"  ADD CONSTRAINT review_rating_range CHECK ("rating" BETWEEN 1 AND 5);
ALTER TABLE "Car"     ADD CONSTRAINT car_price_positive CHECK ("pricePerDay" > 0);
