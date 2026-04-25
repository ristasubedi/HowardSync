# Howard Sync 🦬

## Table of Contents
1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)
5. [Sprint Progress](#Sprint-Progress)

---

## Overview
### Description
**Howard Sync** is a centralized mobile ecosystem designed specifically for Howard University students. It consolidates fragmented campus resources—academic schedules, real-time dining data, indoor navigation, and student organization feeds—into a single, intuitive interface. The goal is to reduce "administrative friction" and foster a stronger, more connected campus community.

### App Evaluation
* **Category:** Education / Social / Productivity
* **Mobile:** Mobile-first design utilizing GPS for navigation, push notifications for safety alerts, and camera integration for QR/ID scanning.
* **Story:** Solves the "First-Week Confusion" and the "Information Gap" by providing a reliable, all-in-one source for campus life that physical maps and scattered emails often fail to provide.
* **Market:** Primarily the 12,000+ Howard University student body; secondary market includes faculty and staff.
* **Habit:** High frequency (Daily). Students check the app for class locations, dining menus, and safety features throughout the day.
* **Scope:** Broad in utility but narrow in focus (HU-specific). It starts as a resource hub with potential to scale into a full social networking platform for Bison.

---

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**
* [x] User can log in via Howard University credentials (SSO).
* [x] User can view their daily class schedule and room numbers.
* [x] User can view a campus map with real-time location tracking (GPS).
* [x] User can view daily dining menus and estimated wait times for Blackburn and Bethune Annex.
* [x] User can browse a feed of upcoming campus events and organization meetings.
* [x] User can access "Bison Safe" emergency buttons for campus security.

**Optional Nice-to-have Stories**
* [ ] User can "Check-in" to study spots to show friends where they are.
* [ ] User can receive push notifications when their favorite meal is served.
* [ ] AI-powered chatbot to answer FAQs (e.g., "Where is the financial aid office?").
* [ ] Integration with laundry room timers to see available machines.

### 2. Screen Archetypes
* **Login Screen**
    * User can log in using their university email/ID.
* **Home Dashboard**
    * User can see a summary of their next class, current dining menu highlights, and trending events.
* **Campus Map Screen**
    * User can search for buildings (e.g., Locke Hall) and see their live GPS position.
* **Bison Feed (Events)**
    * User can scroll through a list of events and "heart" them to save to their calendar.
* **Dining Screen**
    * User can toggle between different dining halls to see menus and "busy-ness" meters.
* **Profile/Settings Screen**
    * User can edit their major, graduation year, and notification preferences.

### 3. Navigation

**Tab Navigation (Tab to Screen)**
* **Home:** Overview of the user's day.
* **Map:** Campus navigation and building directory.
* **Feed:** Campus-wide events and organization updates.
* **Dining:** Menus and wait times.
* **Profile:** User settings and personal saved events.

**Flow Navigation (Screen to Screen)**
* **Login Screen** -> Home Dashboard
* **Home Dashboard** -> Map Screen (when tapping a class location)
* **Home Dashboard** -> Dining Screen (when tapping "See Full Menu")
* **Bison Feed Screen** -> Event Detail View
* **Dining Screen** -> Nutritional Info/Expanded Menu

---

## Wireframes

### Low-Fidelity Sketch
![Wireframe Sketch](assets/wireframes/low-fidelity/sketch.png)

### Iterated Wireframe
![Wireframe](assets/wireframes/low-fidelity/wireframe.png)

*(Note: The above image combines all wireframe screens. To view the 8 individual low-fidelity wireframe screens, please check the [individual-wireframes](assets/wireframes/low-fidelity/individual-wireframes/) folder.)*

### Digital Wireframes
![01 - Login](assets/wireframes/prototype/01-login.png)
![02 - Home](assets/wireframes/prototype/02-home.png)
![03 - Map](assets/wireframes/prototype/03-map.png)
![04 - Feed](assets/wireframes/prototype/04-feed.png)
![05 - Dining](assets/wireframes/prototype/05-dining.png)
![05 - Dining Details](assets/wireframes/prototype/05-dining-details.png)
![06 - Profile](assets/wireframes/prototype/06-profile.png)

### Interactive Prototype Video
![Prototype GIF](assets/wireframes/prototype/prototype.gif)

---

## Schema 

### Models
| Property      | Type     | Description |
| ------------- | -------- | ----------- |
| `userId`      | String   | Unique id for the user (HU ID) |
| `userName`    | String   | Student's full name |
| `userMajor`   | String   | Student's academic major |
| `eventTitle`  | String   | Name of the campus event |
| `eventTime`   | DateTime | Date and time of the event |
| `location`    | GeoPoint | GPS coordinates for map pinning |

### Networking
* **Home Screen**
    * (Read/GET) Query logged-in user's class schedule.
    * (Read/GET) Fetch current daily menu from Dining API.
* **Feed Screen**
    * (Read/GET) Fetch all upcoming events.
    * (Create/POST) Allow Student Orgs to post new events.

---

## Sprint Progress

### 🏗️ Build Sprint 1 — Completed

**Sprint Goal:** Implement core UI screens from wireframes with sample data and tab navigation.

#### Completed User Stories
- [x] **Login Screen** — Branded Howard University login with SSO button, gradient background, entrance animations, and email/password fields.
- [x] **Home Dashboard** — Greeting with time-of-day, next class card with room/time, Bison Safe emergency button, dining wait-time preview, upcoming events section.
- [x] **Campus Map** — Full MapKit integration with Howard University building pins, search bar, building detail bottom sheet, and "Get Directions" (opens Apple Maps).
- [x] **Bison Feed** — Event cards with color banners, heart/save toggle, category filters (Today / This Week / Clubs / Sports), empty state handling.
- [x] **Dining Screen** — Toggle between Blackburn and Bethune Annex, open/closed status badge, wait time display, busyness progress bar, menu preview with full menu sheet.
- [x] **Profile Screen** — User info card with initials avatar, stats (Events/Classes/GPA), settings menu (Notifications, Saved Events, Schedule, Settings), logout with confirmation.
- [x] **Tab Navigation** — 5-tab bar (Home, Map, Feed, Dining, Profile) with Howard Blue tint.
- [x] **Bison Safe** — Emergency alert dialog with Call Campus Police and Share Location options.
- [x] **Design System** — HU brand colors (Bison Blue #001F5F, Bison Red #C70D2E), consistent card styles, typography hierarchy.

#### Build Progress Demo

<img src="assets/wireframes/prototype/first_sprint.gif" width="250"/>


#### Files Created

```
howardsync/howardsync/
├── ContentView.swift           (Root view with login state management)
├── howardsyncApp.swift         (App entry point)
├── Theme.swift                 (HU brand design system)
├── Models/
│   ├── User.swift              (User data model)
│   ├── ClassSchedule.swift     (Class schedule model)
│   ├── CampusEvent.swift       (Event model with categories)
│   ├── DiningHall.swift        (Dining hall + menu models)
│   └── CampusBuilding.swift    (Building model with coordinates)
└── Views/
    ├── LoginView.swift         (Login screen with SSO)
    ├── HomeView.swift          (Home dashboard)
    ├── MapView.swift           (Campus map with MapKit)
    ├── FeedView.swift          (Bison Feed event browser)
    ├── DiningView.swift        (Dining halls + menus)
    ├── ProfileView.swift       (Profile & settings)
    └── MainTabView.swift       (Tab bar navigation)
```

---

### 🚀 Build Sprint 2 — Completed

**Sprint Goal:** Make all features functional with data persistence, working interactions, and polished UX.

#### Completed User Stories — Sprint 2

- [x] **#9 — Login with Validation** — Email validation for `@bison.howard.edu`, loading spinner during authentication, error message display, persisted login state across app launches.
- [x] **#10 — User Profile Persistence** — Edit profile (name, major, graduation year) with data saved to UserDefaults, changes persist across sessions.
- [x] **#11 — Saved Events Logic** — Heart/save events with haptic feedback + scale animation, saved events persist via AppState, dedicated Saved Events list (accessible from Profile) with swipe-to-unsave.
- [x] **#12 — Dining API Connector** — Mock dining service protocol (swappable with a real API), menus change by meal period (Breakfast / Lunch / Dinner), pull-to-refresh, loading states, meal period indicator.
- [x] **#13 — Event Detail View** — Full-screen detail with hero color banner, category badge, event description, date/time/location details, "Save Event" button with haptic feedback, share sheet.
- [x] **#14 — Class Schedule CRUD** — Full schedule management: add, edit, and delete classes. Day-of-week grouping, swipe-to-delete, time pickers, validation, data persistence.
- [x] **#15 — Push Notification Service** — Local notification system using `UNUserNotificationCenter`, class reminders (15 min before), event reminders for saved events, notification preferences UI with system settings link.
- [x] **#16 — Bison Safe Logic** — Full emergency screen with pulsing SOS animation, real phone call links (Campus Police, DC 911, Health Center, Counseling), share GPS location via share sheet, safety tips section.
- [x] **#17 — Dark Mode Feature** — System-adaptive theme colors, dark mode toggle in Profile settings, persisted preference, all views use adaptive backgrounds.

#### Architecture Improvements
- **AppState** — Centralized `@Observable` state manager with `UserDefaults` persistence for user profile, saved events, class schedule, and preferences.
- **DiningService** — Protocol-based service layer (`DiningServiceProtocol`) with swappable mock/live implementations.
- **NotificationService** — Singleton service for scheduling and managing local notifications.

#### New & Updated Files

```
howardsync/howardsync/
├── AppState.swift              (NEW — Central state manager with persistence)
├── ContentView.swift           (UPDATED — AppState, dark mode, notification perms)
├── howardsyncApp.swift         (App entry point)
├── Theme.swift                 (UPDATED — Adaptive colors for dark mode)
├── Models/
│   ├── User.swift              (User data model — Codable)
│   ├── ClassSchedule.swift     (UPDATED — Codable, stable IDs, CRUD support)
│   ├── CampusEvent.swift       (UPDATED — Descriptions, stable IDs)
│   ├── DiningHall.swift        (UPDATED — Meal period support)
│   └── CampusBuilding.swift    (Building model with coordinates)
├── Services/
│   ├── DiningService.swift     (NEW — Protocol + mock dining API)
│   └── NotificationService.swift (NEW — Local notification manager)
└── Views/
    ├── LoginView.swift         (UPDATED — Validation, loading, error states)
    ├── HomeView.swift          (UPDATED — AppState, BisonSafe sheet)
    ├── MapView.swift           (Campus map with MapKit)
    ├── FeedView.swift          (UPDATED — Persisted saves, detail navigation)
    ├── EventDetailView.swift   (NEW — Full event detail with share)
    ├── SavedEventsView.swift   (NEW — Saved events list)
    ├── ScheduleView.swift      (NEW — Schedule management)
    ├── AddClassView.swift      (NEW — Add/edit class form)
    ├── BisonSafeView.swift     (NEW — Emergency services)
    ├── DiningView.swift        (UPDATED — Service layer, loading, refresh)
    ├── ProfileView.swift       (UPDATED — Edit profile, dark mode, all menus)
    └── MainTabView.swift       (UPDATED — AppState, NavigationStack)
```

---

### 📽 Demo Day

#### Demo Video

> **TODO:** Add your 2-4 minute demo video link below after recording.

<div>
    <a href="YOUR_YOUTUBE_OR_VIMEO_LINK_HERE">
        <img src="assets/wireframes/prototype/first_sprint.gif" width="250" alt="Demo Video"/>
    </a>
   <h2>Final Demo link:</h2>
   <p>>https://www.loom.com/share/97dd0a5ed66545ae93dc9a95402d5a20</p>
</div>

<!-- Replace the link above with your actual YouTube/Vimeo URL -->
<!-- Example: https://www.youtube.com/watch?v=YOUR_VIDEO_ID -->
