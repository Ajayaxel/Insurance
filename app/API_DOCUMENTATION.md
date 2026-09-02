# Insurance Mobile App API Documentation

Comprehensive API specification for the **Insurance Mobile App** (supporting both **Policyholder** and **Agent** realms).

---

## 📌 Architectural Overview & Core Principles

- **Portal Scoped Endpoints**: Mobile clients consume **only `/portal/*` endpoints**.
  - Policyholder route prefix: `/portal/me/insurance/*` (20 routes)
  - Agent route prefix: `/portal/me/insurance-agent/*` (7 routes)
  - *Note*: Staff back-office `/insurance/*` routes must never be exposed to mobile applications to prevent unauthorized access across broker records.
- **Authentication**:
  - Secured via HTTP Header: `Authorization: Bearer {{portalToken}}`
  - Token is retrieved via login or OTP verification and applied across all requests.
- **Multi-Tenant / Multi-Broker Support**:
  - `orgSlug` is mandatory for OTP request/verification and registration number logins because users can hold policies across multiple brokers on the platform.

---

## 🔑 00 · Auth Endpoints

All authentication endpoints set or validate `{{portalToken}}`.

### 1. Policyholder Login (Password)
- **Method / Endpoint**: `POST {{baseUrl}}/portal/auth/login`
- **Description**: Sign in policyholder with email or registration number.
- **Request Body (JSON)**:
  ```json
  {
    "email": "{{portalEmail}}",
    "password": "{{portalPassword}}"
  }
  ```
  *(Or `registrationNumber` + `orgSlug`)*

---

### 2. Agent Login (Password)
- **Method / Endpoint**: `POST {{baseUrl}}/portal/auth/login`
- **Description**: Sign in an agent (Requires user context `ctx.type == 'INSURANCE_AGENT'`). A policyholder token will receive a `403 Forbidden` response when accessing agent endpoints.
- **Request Body (JSON)**:
  ```json
  {
    "email": "{{agentEmail}}",
    "password": "{{agentPassword}}"
  }
  ```

---

### 3. Request OTP Code
- **Method / Endpoint**: `POST {{baseUrl}}/portal/auth/otp/request`
- **Description**: Passwordless authentication request. `orgSlug` is required to prevent issuing codes under the wrong broker book.
- **Request Body (JSON)**:
  ```json
  {
    "phone": "{{portalPhone}}",
    "orgSlug": "{{orgSlug}}"
  }
  ```

---

### 4. Verify OTP Code
- **Method / Endpoint**: `POST {{baseUrl}}/portal/auth/otp/verify`
- **Description**: Verifies OTP code and activates the account if not already activated. Sets `{{portalToken}}`.
- **Request Body (JSON)**:
  ```json
  {
    "phone": "{{portalPhone}}",
    "orgSlug": "{{orgSlug}}",
    "code": "{{otpCode}}"
  }
  ```

---

### 5. Who Am I (Token Validation)
- **Method / Endpoint**: `GET {{baseUrl}}/portal/auth/me`
- **Description**: Lightweight health check to verify token validity and determine current user realm.

---

## 🏠 01 · Policyholder — Home & Policies

### 1. Overview (Home Screen)
- **Method / Endpoint**: `GET {{baseUrl}}/portal/me/insurance/overview`
- **Description**: Main payload call on app startup for policyholder dashboard.

---

### 2. My Policies
- **Method / Endpoint**: `GET {{baseUrl}}/portal/me/insurance/policies`
- **Description**: Retrieves list of active/past policies. Captures `{{policyId}}`.

---

### 3. Policy Document (PDF Binary)
- **Method / Endpoint**: `GET {{baseUrl}}/portal/me/insurance/policies/{{policyId}}/document`
- **Description**: Downloads binary PDF. Recommended to stream directly to local file storage/viewer.

---

### 4. Policy Documents List
- **Method / Endpoint**: `GET {{baseUrl}}/portal/me/insurance/policies/{{policyId}}/documents`
- **Description**: Fetches list of all associated policy attachments/documents.

---

### 5. Tax Certificate (80D)
- **Method / Endpoint**: `GET {{baseUrl}}/portal/me/insurance/tax-certificate`
- **Query Parameters**:
  - `financialYear` (e.g., `2025-2026`)
- **Description**: Returns tax certificate data. *Note*: Shows total premium paid inclusive of tax (customer view).

---

### 6. Renew a Policy
- **Method / Endpoint**: `POST {{baseUrl}}/portal/me/insurance/policies/{{policyId}}/renew`
- **Request Body**: `{}`
- **Description**: Initiates a renewal request. The existing policy is kept as historical record.

---

## 📑 02 · Policyholder — Claims & Support

### 1. My Claims
- **Method / Endpoint**: `GET {{baseUrl}}/portal/me/insurance/claims`
- **Description**: Lists all filed claims and their statuses.

---

### 2. Raise a Claim
- **Method / Endpoint**: `POST {{baseUrl}}/portal/me/insurance/policies/{{policyId}}/claims`
- **Request Body (JSON)**:
  ```json
  {
    "incidentDate": "2026-08-01",
    "description": "Rear-ended at a signal; bumper and tail lamp damaged.",
    "estimatedAmountInr": 45000
  }
  ```

---

### 3. Attach Claim Documents
- **Method / Endpoint**: `PATCH {{baseUrl}}/portal/me/insurance/claims/{{claimId}}/docs`
- **Request Body (JSON)**:
  ```json
  {
    "documents": [
      {
        "key": "fir_copy",
        "url": "https://example.com/fir.pdf"
      }
    ]
  }
  ```

---

### 4. Support Tickets List
- **Method / Endpoint**: `GET {{baseUrl}}/portal/me/insurance/support`
- **Description**: Retrieves history of user support tickets.

---

### 5. Open Support Ticket
- **Method / Endpoint**: `POST {{baseUrl}}/portal/me/insurance/support`
- **Request Body (JSON)**:
  ```json
  {
    "subject": "Update my registered mobile number",
    "message": "Please change it to 98460 12345."
  }
  ```

---

## 📝 03 · Policyholder — Declarations

### 1. Declaration Form Schema
- **Method / Endpoint**: `GET {{baseUrl}}/portal/me/insurance/declarations/form`
- **Query Parameters**: `category` (e.g., `health`, `motor`)
- **Description**: Dynamic form schema renderer payload.

---

### 2. My Declarations
- **Method / Endpoint**: `GET {{baseUrl}}/portal/me/insurance/declarations`
- **Description**: Lists existing declaration records.

---

### 3. One Declaration Details
- **Method / Endpoint**: `GET {{baseUrl}}/portal/me/insurance/declarations/{{declarationId}}`

---

### 4. Save Draft Answers
- **Method / Endpoint**: `PATCH {{baseUrl}}/portal/me/insurance/declarations/{{declarationId}}`
- **Request Body (JSON)**:
  ```json
  {
    "answers": {
      "tobacco": false,
      "existingConditions": []
    }
  }
  ```
- **Description**: Idempotent draft saving while user types.

---

### 5. Submit Declaration
- **Method / Endpoint**: `POST {{baseUrl}}/portal/me/insurance/declarations/{{declarationId}}/submit`
- **Request Body**: `{}`

---

### 6. Revise After Submit
- **Method / Endpoint**: `POST {{baseUrl}}/portal/me/insurance/declarations/{{declarationId}}/revise`
- **Request Body**: `{}`
- **Description**: Creates a **NEW** revision instance rather than modifying the existing signed record.

---

### 7. Print Signed PDF
- **Method / Endpoint**: `GET {{baseUrl}}/portal/me/insurance/declarations/{{declarationId}}/print`
- **Description**: Generates signed declaration PDF.

---

## 👤 04 · Policyholder — Profile

### 1. My Profile
- **Method / Endpoint**: `GET {{baseUrl}}/portal/me/insurance/profile`

---

### 2. Update Profile
- **Method / Endpoint**: `PATCH {{baseUrl}}/portal/me/insurance/profile`
- **Request Body (JSON)**:
  ```json
  {
    "phone": "9846012001",
    "email": "rajesh.menon@example.com"
  }
  ```

---

## 👔 05 · Agent App

*All agent endpoints require `ctx.type == 'INSURANCE_AGENT'` token context.*

### 1. Agent Profile
- **Method / Endpoint**: `GET {{baseUrl}}/portal/me/insurance-agent/profile`

---

### 2. My Business Overview
- **Method / Endpoint**: `GET {{baseUrl}}/portal/me/insurance-agent/business`
- **Description**: Returns agent commission earnings book. Shows net agent share.

---

### 3. Agent Policies List
- **Method / Endpoint**: `GET {{baseUrl}}/portal/me/insurance-agent/policies`

---

### 4. One Policy Detail
- **Method / Endpoint**: `GET {{baseUrl}}/portal/me/insurance-agent/policies/{{agentPolicyId}}`

---

### 5. Statement
- **Method / Endpoint**: `GET {{baseUrl}}/portal/me/insurance-agent/statement`
- **Query Parameters**: `from` (e.g., `2026-01-01`), `to` (e.g., `2026-08-31`)

---

### 6. Settlements List
- **Method / Endpoint**: `GET {{baseUrl}}/portal/me/insurance-agent/settlements`

---

### 7. One Settlement Details
- **Method / Endpoint**: `GET {{baseUrl}}/portal/me/insurance-agent/settlements/{{settlementId}}`
- **Description**: Detailed breakdown of paid settlement including adjustment rows.
