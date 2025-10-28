import express from "express";
const app = express();
app.get("/", (_req,res)=>res.send("OK root"));
app.get("/users", (_req,res)=>res.json([{name:"Diag User"}]));
app.listen(4000, ()=>console.log("diag listening on http://localhost:4000"));
