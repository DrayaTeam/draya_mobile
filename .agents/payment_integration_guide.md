# Payment Integration Guide — Web & Mobile

This guide describes the payment flow that Frontend (Web/React) and Mobile (Flutter) clients must implement using the new payment architecture.

## 1. Payment Flow Overview

The payment flow consists of three phases:

1. Initiation
2. Execution
3. Verification

```text
User clicks Buy Course / Top Up Wallet
        ↓
Phase 1: Initiation
        ↓
Backend returns checkoutUrl
        ↓
Phase 2: Execution
        ↓
User pays on Paymob
        ↓
Phase 3: Verification
        ↓
App receives redirect
        ↓
Extract transactionId
        ↓
Poll backend for actual status
        ↓
Display final result
```

## 2. Phase 1 — Initiation

For Classroom Enrollment:

```http
POST /api/v1/classrooms/{classroomId}/checkout
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json
```

### Request

Flutter:

```json
{
  "redirectionUrl": "draya://payment-result"
}
```

Web:

```json
{
  "redirectionUrl": "https://draya.com/payment/result"
}
```

The client MUST send the exact Deep Link (Flutter) or Route (Web) that the browser should return to after payment.

Do not send price, email, name, or phone number. The backend retrieves these securely from the database using the JWT token.

### Response

```json
{
  "checkoutUrl": "https://accept-alpha.paymob.com/unifiedcheckout/?publicKey=...&clientSecret=..."
}
```

## 3. Phase 2 — Execution

Open the returned `checkoutUrl` and let the user complete payment on the secure Paymob page.

The application does not handle sensitive card data.

### Web

```javascript
window.location.href = response.checkoutUrl;
```

### Flutter

Use an in-app browser package such as:

- `url_launcher`
- `webview_flutter`

## 4. Phase 3 — Verification

After payment, Paymob redirects to the backend callback. The backend processes it and issues an HTTP `302 Redirect` to the exact `redirectionUrl` supplied during initiation.

## 5. Handling the Redirect

Flutter receives URLs such as:

```text
draya://payment-result?transactionId=b5c...&status=success
```

or:

```text
draya://payment-result?transactionId=b5c...&status=failed
```

Configure the app to intercept this deep link. Packages mentioned by the guide include:

- `uni_links`
- `app_links`

For Web, configure the router to handle:

```text
/payment/result
```

and extract the query parameters.

## 6. Security — Never Trust URL Status

Never trust:

```text
status=success
```

from the redirect URL. A user could modify it manually.

Extract `transactionId` and ask the backend for the actual payment status.

## 7. Payment Status

```http
GET /api/v1/payments/{transactionId}/status
Authorization: Bearer <JWT_TOKEN>
```

This endpoint is the source of truth because the backend webhook may take a few seconds to process the payment.

### Response

```json
{
  "paymentTransactionId": "b5c...",
  "status": "Completed",
  "grossAmount": 500.0,
  "purpose": "ClassroomEnrollment",
  "classroomId": "a3b...",
  "isEnrolled": true
}
```

### PaymentStatusDto

| Field | Description |
|---|---|
| `paymentTransactionId` | Payment transaction identifier |
| `status` | Current payment status |
| `grossAmount` | Payment amount |
| `purpose` | Payment purpose |
| `classroomId` | Related classroom ID |
| `isEnrolled` | Whether the student is enrolled |

## 8. UI Logic

### Completed

When:

```text
status == "Completed" AND isEnrolled == true
```

- Show Success UI.
- Navigate the user to the classroom.

### Pending

When:

```text
status == "Pending"
```

- Show a loading spinner.
- Retry the status endpoint every 3 seconds.
- Retry 5–10 times.

```text
Pending
  ↓
Loading Spinner
  ↓
Wait 3 seconds
  ↓
GET /payments/{transactionId}/status
  ↓
Still Pending?
  ├─ Yes → Retry
  └─ No  → Handle final status
```

### Failed

When:

```text
status == "Failed"
```

- Show Failure UI.
- Provide an option to try again.

## 9. Flutter Flow

```text
Buy Course
    ↓
POST /classrooms/{id}/checkout
    ↓
Send redirectionUrl
    ↓
Receive checkoutUrl
    ↓
Open Paymob Checkout
    ↓
User completes payment
    ↓
Paymob → Backend
    ↓
HTTP 302 Redirect
    ↓
draya://payment-result?transactionId=...&status=...
    ↓
Capture Deep Link
    ↓
Extract transactionId
    ↓
GET /payments/{transactionId}/status
    ↓
Completed / Pending / Failed
```

## 10. Web Flow

```text
Buy Course
    ↓
POST /classrooms/{id}/checkout
    ↓
Receive checkoutUrl
    ↓
window.location.href = checkoutUrl
    ↓
Paymob Checkout
    ↓
Payment completes
    ↓
Paymob → Backend
    ↓
HTTP 302 Redirect
    ↓
/payment/result?transactionId=...&status=...
    ↓
Extract transactionId
    ↓
GET /payments/{transactionId}/status
    ↓
Completed / Pending / Failed
```

## 11. Agent Implementation Rules

1. Always send the JWT Bearer token.
2. Always send the exact `redirectionUrl` during checkout initiation.
3. Do not send price, email, name, or phone number in the checkout request.
4. Use the backend `checkoutUrl` to open Paymob Checkout.
5. Never handle sensitive card data inside the application.
6. Configure Flutter deep-link handling for `draya://payment-result`.
7. Configure the web router for `/payment/result`.
8. Extract `transactionId` from the redirect URL.
9. Never trust the `status` query parameter in the redirect URL.
10. Always call the payment-status endpoint for the real result.
11. Treat `GET /api/v1/payments/{transactionId}/status` as the source of truth.
12. When `Pending`, retry every 3 seconds for approximately 5–10 attempts.
13. When `Completed` and `isEnrolled == true`, show success and navigate to the classroom.
14. When `Failed`, show failure UI and allow retry.
15. Do not assume a successful Paymob redirect means backend processing is already complete.
