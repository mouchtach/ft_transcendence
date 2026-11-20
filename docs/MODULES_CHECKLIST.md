# Modules Checklist (checked against the official ft_transcendence subject)

Need 14 points. Each module is demonstrated live at evaluation; an incomplete one counts as 0.

| # | Module (official name) | Type | Pts | What the subject requires | Our feature that covers it | Gaps to close |
|---|---|---|---|---|---|---|
| 1 | Use a framework for frontend and backend | Major | 2 | A frontend framework and a backend framework | React + NestJS | none |
| 2 | Real-time features using WebSockets | Major | 2 | Real-time updates across clients, graceful connect/disconnect, efficient broadcasting | Socket.IO: notifications, chat, tracking, booking updates | Rooms (no broadcast to everyone), reconnect handling, show it with 2 browsers |
| 3 | Users interact with other users | Major | 2 | Basic chat, profile system, friends system (add/remove, list) | Chat, profile page, friends | Friends list must be demoable |
| 4 | Use an ORM | Minor | 1 | ORM for the database | Prisma | none |
| 5 | Standard user management and authentication | Major | 2 | Update profile, upload avatar (default if none), friends with online status, profile page | Auth + users + presence dot | Avatar upload with default image; online status visible |
| 6 | Remote authentication with OAuth 2.0 | Minor | 1 | Google, GitHub, 42 etc. | Google OAuth | none |
| 7 | Advanced permissions system | Major | 2 | CRUD on users, roles management, different views and actions per role | 5 roles, permission matrix, Super Admin user CRUD | Super Admin must be able to view, edit, delete users and manage roles, not only ban |
| 8 | Advanced analytics dashboard with data visualization | Major | 2 | Interactive charts (line, bar, pie), real-time data updates, export (PDF, CSV), customizable date ranges and filters | Agency analytics | Needs export (CSV at least, PDF ideally), date-range filter, live refresh when a booking changes |
| | **Total** | | **14** | | | |

Margin: this is exactly 14 with zero spare. Cheap extra points to add as insurance (each demonstrable, listed in the subject):
- Minor: advanced search with filters, sorting and pagination (already built into `/cars`) = 1
- Minor: multiple languages (3+) with switcher = 1; RTL support = 1 (the Carscendence prototype already has EN/FR/AR)
- Minor: complete notification system for create/update/delete actions = 1
- Minor: file upload and management = 1 (avatars and car photos, if you add validation, preview, progress, delete)

## Mandatory items that are easy to forget (subject, "mandatory part")

- Privacy Policy and Terms of Service pages: real content, linked in the footer. Placeholder pages mean rejection.
- Everything over HTTPS (nginx handles it here).
- `.env` ignored by Git, `.env.example` committed.
- Forms validated in frontend AND backend.
- No warnings or errors in the Chrome console.
- Multi-user safe: concurrent users, no race conditions (the DB overlap constraint covers bookings).
- Single command launch: `docker compose up --build`.
- Commits from all 5 members with meaningful messages.
- README in English with team roles, project management, stack, DB schema, features, modules/points, individual contributions.

## Scope warning

The Carscendence subject you attached (dated Oct 9) describes a smaller version: Express, SQLite, 2 containers, no GPS/analytics/employees, 10 modules. FleetFlow as you described it (NestJS, PostgreSQL, 3 containers, GPS, employees) is larger. Decide once as a team and keep one document as the truth. This repo follows FleetFlow.
