# Project Work Report

• **Project**: Insurance App (Green Turbo)
• **Tasks Completed**: 
  - Scalable Feature-wise Clean Architecture & BLoC Directory Setup
  - Policyholder & Agent API Specifications Documentation
  - Login API Integration (`POST /portal/auth/login`)
  - Passwordless OTP Request (`POST /portal/auth/otp/request`) & Verification (`POST /portal/auth/otp/verify`)
  - Policyholder Multi-Mode Login UI (Email, Registration No., OTP Code)
  - Persistent Token & Session Storage via `SharedPreferences` & `AuthLocalDataSource`
  - Auto-Authentication check on startup (`CheckAuthStatusEvent`)
  - Centralized Navigation Routing (`AppRouter` with `/login` and `/home` routes)
  - Policyholder Home Screen Dashboard UI with Quick Action Cards & Logout handling
  - Custom Brand Primary & Button Color Theme (`#122376`)
  - HTTP Request & Response Console Logger
• **Bugs Fixed**:
  - Email Validation Regex (Fixed rejection of long TLDs like `.example`, `.technology`)
  - Flutter Color Deprecation Warnings (`withOpacity` -> `withValues`)
  - Relative Import paths in `HomePage` & `widget_test.dart`
  - Unit & Widget Test Setup Fixes
• **Pending**:
  - Policyholder My Policies & Binary PDF Document Viewer (`GET /portal/me/insurance/policies`)
  - Claims Filing & Document Uploads (`POST /portal/me/insurance/policies/{id}/claims`)
  - Agent Realm Portal Views (`/portal/me/insurance-agent/*`)
  - Push Notifications & Support Tickets
• **Status**: ⏳ In Progress (Auth Layer & Persistent Token Navigation 100% Completed & Verified)
