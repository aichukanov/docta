
-- Seed services and purchase for clinic 20.
INSERT IGNORE INTO billing_paid_services (name)
VALUES ('dofollow'), ('highlight');

INSERT INTO billing_clinic_service_purchases (
  clinic_id,
  price,
  purchased_at,
  valid_until
) VALUES (
  20,
  20.00,
  '2026-01-18 00:00:00',
  '2026-07-18 00:00:00'
);

SET @purchase_id := LAST_INSERT_ID();

INSERT INTO billing_clinic_service_purchase_items (purchase_id, service_id)
SELECT @purchase_id, s.id
FROM billing_paid_services s
WHERE s.name IN ('dofollow', 'highlight');
