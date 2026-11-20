# FleetFlow

Real-time vehicle rental and fleet management platform (ft_transcendence).

Customers browse and book cars. Agencies manage fleet, reservations, employees, live vehicle map and analytics.

## Quick start

```bash
cp .env.example .env     # fill in secrets
docker compose up --build
# open https://localhost:8443 (accept the self-signed certificate)
```

Containers: `frontend` (nginx + React, the only exposed one), `backend` (NestJS + Socket.IO), `database` (PostgreSQL).

## Where to read

- `docs/SYSTEM_DESIGN.md`: containers, module graph, ER diagram, booking flow, real-time and auth design
- `docs/FILE_MAP.md`: every folder/file, who depends on whom, page → API map, build order
- `docs/MODULES_CHECKLIST.md`: 14 points checked against the official subject, plus mandatory items

## Team and ownership

| # | Domain |
|---|---|
| 1 | Lead: architecture, auth, users, security, admin |
| 2 | Customer app: cars, search, bookings, reviews |
| 3 | Agency: fleet, employees, permissions |
| 4 | Real-time: sockets, tracking, chat, notifications |
| 5 | Analytics, tests, Docker/HTTPS |

(Names, project management approach, individual contributions, challenges: to complete before evaluation.)

## Git workflow

`main` (stable) ← `develop` ← `feature/*`. Pull request into `develop`, at least one review, Conventional Commit messages (`feat(auth): ...`).
