# ADR-003: Customer Verification - QR Code Only

## Status

**Proposed**

## Context

Requirements specify:
- QR code only verification for BOPIS pickup
- No additional ID or phone verification required
- Customer pickup wait time under 5 minutes
- Secure order verification and completion

The fulfillment domain must balance security with customer convenience while preventing order fraud.

## Decision

Generate unique QR code per order containing order identifier and cryptographic signature. Store associates scan QR code via tablet app to validate order and complete pickup.

### QR Code Design

- **Content**: order_id + digital_signature (HMAC or asymmetric signature)
- **Generation**: Order Management Service generates QR code on order placement
- **Storage**: QR code sent to customer via email/SMS notification
- **Validity**: QR code valid from order ready until 7 days after order readiness
- **Security**: Cryptographic signature prevents QR code tampering and reuse

### Pickup Flow

1. **Customer Arrival**:
   - Customer presents QR code on mobile device
   - QR code contains order_id and signature

2. **QR Code Verification**:
   - Store associate scans QR code via tablet app
   - Fulfillment domain validates:
     - Order exists and status is READY
     - Signature is valid (not tampered)
     - Order is within 7-day validity window
   - On success: Order details displayed for fulfillment

3. **Order Fulfillment**:
   - Associate marks order as PICKED_UP
   - Pickup Event published to Order domain
   - POS transaction recorded (optional for compliance)

4. **Order Completion**:
   - Order status finalizes to PICKED_UP
   - Customer receives order completion confirmation (optional)

### Security Measures

- **Digital Signature**: QR code signed with private key, verified with public key
- **One-Time Use**: QR code invalidated after successful pickup
- **Time-Based Validity**: QR code expires 7 days after order readiness
- **Audit Trail**: All QR code scans logged for fraud detection
- **Rate Limiting**: Failed verification attempts limited per order

## Consequences

### Benefits

1. **Fast Pickup**: QR code scan takes < 10 seconds, contributes to < 5-minute wait time goal
2. **Customer Convenience**: No additional ID or phone verification steps
3. **Security**: Digital signature prevents tampering and order theft
4. **Auditability**: All pickups logged with timestamp, associate, and order
5. **No Hardware Dependency**: Standard tablet camera sufficient (no specialized RFID/NFC)

### Trade-offs

1. **Lost Device**: Customer with lost device cannot access QR code (requires order recovery process)
2. **QR Code Fraud**: Screenshots/screensharing could be misused (mitigated by one-time use and signature)
3. **No Physical Verification**: Associates do not physically verify customer identity (acceptable for non-regulated items)
4. **Key Management**: Requires secure private key storage and rotation policy

## Alternatives Considered

### 1. Order Number + Phone Verification

**Description**: Customer provides order number and phone number for verification. System sends SMS verification code to complete pickup.

**Pros**:
- No QR code generation/management
- Phone number verification adds security layer
- Lost device mitigation (phone still works)

**Cons**:
- Slower pickup (SMS round trip adds 30-60 seconds)
- More friction for customer (multiple steps)
- SMS delivery failures block pickup
- Does not meet 5-minute wait time goal when SMS delays occur

**Rejected**: Additional verification steps and SMS dependency violate latency and convenience requirements.

### 2. Government ID Verification

**Description**: Customer presents physical government ID (driver's license, passport) for verification.

**Pros**:
- Strongest security (physical identity verification)
- Prevents order fraud
- Industry standard for high-value items

**Cons**:
- Poor customer experience (friction, privacy concerns)
- Slow pickup process (ID scanning, manual verification)
- Associate training required for ID validation
- Not scalable for 1,000 orders/day
- May violate privacy regulations (GDPR)

**Rejected**: Government ID verification creates customer friction and does not align with convenience-focused requirements. Reserved for high-value regulated items if needed.

### 3. Biometric Verification (Fingerprint/Face)

**Description**: Customer biometric data (fingerprint or face) used for verification.

**Pros**:
- Strong security (unique biometric identity)
- Fast verification once enrolled
- Harder to fraud

**Cons**:
- Requires specialized hardware (biometric readers)
- Privacy and regulatory concerns (GDPR, CCPA)
- Customer enrollment friction
- High implementation cost
- Lost device = lost biometric data

**Rejected**: Biometric verification requires costly hardware and raises privacy concerns disproportionate to BOPIS requirements.

## References

- Requirements: req-005 (Store associate can verify and complete customer pickup)
- Interface: ifc-pickup-api
- Component: architecture/solution/domain-handoffs/fulfillment/component-specs.yml
