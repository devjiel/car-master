# Car Master

A mobile car quiz application, built with Flutter and Supabase.

## Project Structure

The project is organized into two main parts:

- **frontend/**: Flutter mobile application
- **backend/**: Supabase database configuration

## Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) (version 3.7+)
- [Docker](https://www.docker.com/get-started/) to run Supabase locally
- [Git](https://git-scm.com/downloads)

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/your-username/car_master.git
cd car_master
```

### 2. Set up Supabase

Follow the detailed instructions in the [backend README](backend/README.md) to:
- Install Supabase locally
- Create the necessary tables
- Configure the API

### 3. Set up the Flutter application

1. Copy the example environment file
```bash
cd frontend
cp .env.example .env
```

2. Update the `.env` file with your Supabase settings
```
SUPABASE_URL=http://localhost:8000
SUPABASE_ANON_KEY=your-anon-key
```

3. Install dependencies
```bash
flutter pub get
```

## Development

### Launch Supabase

```bash
cd supabase/docker
docker-compose up -d
```

### Launch the Flutter application

```bash
cd frontend
flutter run
```

## Features

- Car image quiz
- Scoring system
- Data persistence with Supabase

## Testing

To run the Flutter application tests:

```bash
cd frontend
flutter test
```

## Architecture

- **Frontend**: Flutter application using Riverpod for state management
- **Backend**: PostgreSQL database managed by Supabase

## Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 