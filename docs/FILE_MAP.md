# FleetFlow: File Map and Relations

"Owner" = the student who leads that folder (everyone can open PRs anywhere; owner reviews). Student numbers follow the team plan.

```
fleetflow/
├── docker-compose.yml          3 services: database, backend, frontend
├── .env.example                every variable; copy to .env
├── .gitignore
├── README.md                   (final README, grows over time)
├── docs/
│   ├── SYSTEM_DESIGN.md        diagrams (this map's companion)
│   ├── FILE_MAP.md             this file
│   └── MODULES_CHECKLIST.md    14 points, what the subject requires, status
├── database/
│   └── init/                   optional SQL run on first start
├── backend/
│   ├── Dockerfile
│   ├── prisma/
│   │   ├── schema.prisma       all tables, single source of truth for the DB
│   │   ├── seed.ts             roles, permissions, SUPER_ADMIN, demo agencies/cars
│   │   └── sql/booking_no_overlap.sql   constraints Prisma cannot express
│   ├── simulator/              (optional) standalone GPS script if not run inside Nest
│   ├── test/                   e2e tests (supertest)
│   └── src/
│       ├── main.ts             bootstrap: ValidationPipe, helmet, cookies, CORS, rate limit, static /uploads
│       ├── app.module.ts       imports every module below
│       ├── common/
│       │   ├── guards/         jwt-auth, roles, permissions, agency-scope
│       │   ├── decorators/     @Roles, @RequirePermission, @CurrentUser, @Public
│       │   ├── filters/        safe error responses (no stack traces)
│       │   └── interceptors/   response shape, logging
│       ├── prisma/             PrismaService (global)
│       ├── auth/               register, login, logout, refresh, Google OAuth
│       ├── users/              profile, avatar upload, user lookup
│       ├── agencies/           agency profile, settings
│       ├── employees/          invite/remove staff, change employee role
│       ├── roles-permissions/  permission matrix read/update
│       ├── cars/               CRUD + search/filter/sort/pagination
│       ├── bookings/           create, list, accept/reject, cancel, price + availability
│       ├── reviews/            create/list reviews of completed bookings
│       ├── friends/            request, accept, remove, list with online status
│       ├── chat/               conversations, messages, unread, history
│       ├── notifications/      create + list + mark read, pushes via realtime
│       ├── realtime/           the one Socket.IO gateway, rooms, presence
│       ├── tracking/           location ingest, latest positions, GPS simulator
│       ├── analytics/          read-only aggregate queries, CSV/PDF export
│       ├── admin/              verify agencies, ban/unban, support message, audit log
│       └── health/             /api/health for Docker and evaluation
└── frontend/
    ├── Dockerfile, nginx.conf
    ├── public/
    └── src/
        ├── main.tsx, app/router.tsx
        ├── api/                Axios client + one file per backend module
        ├── context/            AuthContext
        ├── hooks/              useSocket, useNotifications, useDebounce
        ├── lib/                socket.ts, i18n, validators (zod)
        ├── components/         Navbar, CarCard, NotificationBell, ProtectedRoute, Charts, MapView
        └── pages/
            ├── public/         Home, Cars, CarDetails, Login, Register, Privacy, Terms
            ├── customer/       MyBookings, BookingDetails, History, Profile, Friends, Chat, Notifications
            ├── agency/         Dashboard, Fleet, CarForm, Reservations, Customers, Employees, Permissions, Tracking, Chat, Analytics
            └── admin/          AdminLogin, AdminDashboard, Accounts, AuditLog
```

## Backend module relations (what each imports, what it exposes, who owns it)

| Module | Imports / calls | Exposes to others | REST prefix | DB tables | Owner |
|---|---|---|---|---|---|
| prisma | none | `PrismaService` | none | all | 1 |
| common | none | guards, decorators | none | none | 1 |
| auth | users, prisma | `JwtAuthGuard` strategy, token service | `/auth` | RefreshToken, OAuthAccount | 1 |
| users | prisma | `UsersService.findById` | `/users` | User | 1 |
| agencies | prisma | `AgenciesService.assertStaffOf` | `/agencies` | Agency | 3 |
| employees | agencies, users | none | `/employees` | Employee | 3 |
| roles-permissions | prisma | permission lookup for `PermissionsGuard` | `/roles` | Role, Permission, RolePermission | 3 |
| cars | agencies | `CarsService.assertBookable`, `findOneInScope` | `/cars` | Car | 2 + 3 |
| bookings | cars, notifications | `BookingsService.findCompletedForReview` | `/bookings` | Booking | 2 |
| reviews | bookings | none | `/reviews` | Review | 2 |
| friends | notifications, realtime (presence) | none | `/friends` | Friendship | 4 |
| chat | realtime, notifications | `ChatService.sendSupportMessage` | `/chat` | Conversation, ConversationMember, Message | 4 |
| notifications | realtime | `NotificationsService.notify(userId, type, data)` | `/notifications` | Notification | 4 |
| realtime | auth (JWT verify) | `RealtimeService.emitToUser/emitToAgency/isOnline` | WebSocket `/socket.io` | none | 4 |
| tracking | cars, realtime | none | `/tracking` | Location | 4 |
| analytics | prisma (read only) | none | `/analytics` | Booking, Car, User (read) | 5 |
| admin | users, agencies, chat, notifications | none | `/admin` | AuditLog | 1 |
| health | prisma | none | `/health` | none | 5 |

## Frontend page → API → backend relation

| Page | Calls (REST) | Sockets | Backend module |
|---|---|---|---|
| Login / Register | `POST /auth/login`, `/auth/register`, Google redirect | none | auth |
| Cars, CarDetails | `GET /cars?city=&category=&maxPrice=&page=`, `GET /cars/:id` | none | cars |
| Booking panel (CarDetails) | `POST /bookings` | `booking:updated` | bookings |
| MyBookings | `GET /bookings?mine=true`, `PATCH /bookings/:id` (cancel) | `booking:updated` | bookings |
| Profile | `GET/PATCH /users/me`, `POST /users/me/avatar` | none | users |
| Friends | `GET /friends`, `POST /friends/:id` | `presence` | friends |
| Chat | `GET /chat/conversations`, `GET /chat/:id/messages` | `chat:*` | chat |
| Notification bell | `GET /notifications`, `PATCH /notifications/:id/read` | `notification` | notifications |
| Agency Fleet / CarForm | `GET/POST/PATCH/DELETE /cars` | `car:status` | cars |
| Agency Reservations | `GET /bookings?agency=`, `PATCH /bookings/:id` | `booking:updated` | bookings |
| Agency Employees / Permissions | `/employees`, `/roles` | none | employees, roles-permissions |
| Agency Tracking | `GET /tracking/latest` | `tracking:update` | tracking |
| Agency Analytics | `GET /analytics/*?from=&to=`, `/analytics/export.csv` | refresh on `booking:updated` | analytics |
| Admin Accounts / Audit | `/admin/users`, `/admin/agencies/:id/verify`, `/admin/users/:id/ban`, `/admin/audit` | `admin:kick` (server) | admin |
| Privacy, Terms | none (static, linked in footer) | none | none |

## Build order (matches the dependency graph, so nobody is blocked)

1. prisma, common, auth, users (already started by your teammate)
2. agencies, roles-permissions, employees, cars
3. notifications + realtime (needed by bookings)
4. bookings, reviews
5. friends, chat
6. tracking + simulator
7. analytics, admin
8. health, tests, README, HTTPS check
