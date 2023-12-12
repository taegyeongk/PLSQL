require("dotenv").config({ path: "./mysql/db.env" });
const express = require("express");
const app = express();

app.use(
  express.json({
    limit: "50mb",
  })
);

const server = app.listen(3000, () => {
  console.log("Server started. port 3000.");
});

const db = require("./db.js");

app.get("/boards", async (request, res) => {
  res.send(await db.connection("boardList"));
});

app.get("/boards/:bno", async (request, res) => {
  res.send((await db.connection("boardInfo", request.params.bno))[0]);
});
