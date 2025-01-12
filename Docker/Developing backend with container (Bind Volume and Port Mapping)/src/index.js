const express = require("express");
const app = express();

const PORT = process.env.PORT || 3000;

app.use(express.json());

app.get("/", (req, res) => {
  res.send("Welcome to the Home Route! added docker volume");
});

app.get("/api", (req, res) => {
  res.json({
    message: "Welcome to the API Route!",
    status: "success",
  });
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
