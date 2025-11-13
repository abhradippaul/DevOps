import dotenv from "dotenv";
dotenv.config();

import express, { urlencoded } from "express";
import cors from "cors";
import { jokes } from "./joke.js";

const app = express();
const PORT = process.env.PORT || 8000;
const FRONTEND_URL = process.env.FRONTEND_URL;

app.use(express.json());
app.use(urlencoded({ extended: true }));

app.use(
  cors({
    origin: FRONTEND_URL,
    credentials: true,
  })
);

app.get("/", async (req, res) => {
  res.status(200).json({ msg: "Server is running" });
});

app.get("/api/jokes", async (req, res) => {
  res.status(200).json({ msg: "Fetched jokes successfully", data: jokes });
});

app.listen(PORT, () => {
  console.log("Server connected successfully on port no", PORT);
});
