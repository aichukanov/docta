-- Add deleted flag to billing purchases.

ALTER TABLE billing_clinic_service_purchases
  ADD COLUMN deleted TINYINT(1) NOT NULL DEFAULT 0;

CREATE INDEX idx_billing_purchases_deleted
  ON billing_clinic_service_purchases (deleted);

CREATE INDEX idx_billing_purchases_clinic_deleted_valid_until
  ON billing_clinic_service_purchases (clinic_id, deleted, valid_until);
