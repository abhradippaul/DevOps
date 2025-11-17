import dotenv from "dotenv";
dotenv.config();

import express, { urlencoded } from "express";
import cors from "cors";
import { jokes } from "./joke.js";
import { client, getValueFromRedis, setValueInRedis } from "./utils/redis.js";

const app = express();
const PORT = process.env.PORT || 8000;
const ENV = process.env.ENV || "DEV";

app.use(express.json());
app.use(urlencoded({ extended: true }));

app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);

app.get("/", async (req, res) => {
  const isJokesExist = await getValueFromRedis("jokes");
  if (!isJokesExist) {
    await setValueInRedis("jokes", JSON.stringify(jokes));
  }
  console.log("From Redis Database");
  res.status(200).json({ msg: "Welcome to backend", env: ENV });
});

app.get("/api", async (req, res) => {
  const isJokesExist = await getValueFromRedis("jokes");
  if (!isJokesExist) {
    await setValueInRedis("jokes", JSON.stringify(jokes));
  }
  console.log("From Redis Database");
  res.status(200).json({ msg: "Server is running", env: ENV });
});

app.get("/healthy", (req, res) => {
  res.status(200).json({ msg: "Server is healthy" });
});

app.get("/api/jokes", async (req, res) => {
  const jokeList = await setValueInRedis("jokes", JSON.stringify(jokes));
  if (!jokeList) {
    res.status(404).json({ msg: "Jokes not found" });
  }
  res.status(200).json({ msg: "Fetched jokes successfully", data: jokes });
});

app.listen(PORT, async () => {
  console.log("Server connected successfully on port no", PORT);
  await client.connect();
  console.log("Connected to Redis");
  console.log("Connected to Redis");
});
