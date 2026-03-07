# Solar Monitoring Backend API

Backend service for the **Voice AI Solar Monitoring Dashboard** built using **FastAPI, MongoDB Atlas, and Motor**.

This backend manages solar plants, inverters, sensors, SLMS devices, alerts, and export data.
It provides REST APIs that can be consumed by the **Flutter frontend application**.

---

# Tech Stack

* FastAPI
* MongoDB Atlas
* Motor (Async MongoDB driver)
* Python 3
* Pydantic
* Uvicorn
* Bcrypt

---

# Project Structure

```
solar-backend
│
├── main.py
├── requirements.txt
├── .env
│
├── config
│   └── database.py
│
├── models
│   ├── UserModel.py
│   ├── PlantModel.py
│   ├── InverterModel.py
│   ├── SensorModel.py
│   ├── SLMSModel.py
│   ├── AlertModel.py
│   └── ExportModel.py
│
├── controllers
│   ├── UserController.py
│   ├── PlantController.py
│   ├── InverterController.py
│   ├── SensorController.py
│   ├── SLMSController.py
│   ├── AlertController.py
│   └── ExportController.py
│
└── routes
    ├── UserRoutes.py
    ├── PlantRoutes.py
    ├── InverterRoutes.py
    ├── SensorRoutes.py
    ├── SLMSRoutes.py
    ├── AlertRoutes.py
    └── ExportRoutes.py
```

---

# Setup Instructions

## 1️⃣ Clone the Repository

```
git clone <repository-url>
cd solar-backend
```

---

## 2️⃣ Create Virtual Environment

```
python -m virtualenv venv
```

Activate environment:

Windows

```
venv\Scripts\activate
```

Mac / Linux

```
source venv/bin/activate
```

---

## 3️⃣ Install Dependencies

```
pip install -r requirements.txt
```

---

## 4️⃣ Configure Environment Variables

Create a `.env` file in the root directory.

```
MONGO_URL=mongodb+srv://USERNAME:PASSWORD@CLUSTER.mongodb.net/solar_monitoring_system?retryWrites=true&w=majority
```

Replace:

* USERNAME → MongoDB Atlas username
* PASSWORD → MongoDB Atlas password
* CLUSTER → your cluster name

---

## 5️⃣ Start the Server

```
uvicorn main:app --reload
```

Server will start at:

```
http://127.0.0.1:8000
```

---

# API Documentation

FastAPI automatically generates interactive documentation.

Open:

```
http://127.0.0.1:8000/docs
```

This page allows testing all APIs directly.

---

# API Modules

### User APIs

```
POST /user
POST /user/login
GET  /users
```

### Plant APIs

```
POST /plant
GET  /plants
GET  /plant/{plant_id}
DELETE /plant/{plant_id}
```

### Inverter APIs

```
POST /inverter
GET  /inverters
DELETE /inverter/{inverter_id}
```

### Sensor APIs

```
POST /sensor
GET  /sensors
DELETE /sensor/{sensor_id}
```

### SLMS APIs

```
POST /slms
GET  /slms
DELETE /slms/{device_id}
```

### Alert APIs

```
POST /alert
GET  /alerts
GET  /alert/{alert_id}
DELETE /alert/{alert_id}
```

### Export APIs

```
POST /export
GET  /exports
DELETE /export/{export_id}
```

---

# MongoDB Collections

The following collections will be created automatically:

```
solar_monitoring_system
 ├ users
 ├ plants
 ├ inverters
 ├ sensors
 ├ sensor_data
 ├ slms_devices
 ├ slms_data
 ├ alerts
 └ exports
```

---

# Testing API

Example test endpoint:

```
GET /test
```

Response:

```
{
  "message": "Server running"
}
```

---

# Future Improvements

* JWT Authentication
* Role Based Access
* Sensor time-series data
* AI anomaly detection
* Real-time data streaming
* Export reports

---

# Author

Chirag Khatri
M.Tech Cyber Security
