import { Router } from "express";
const router = Router();

router.get("/", (_req, res) => {
  res.json([{ name: "From router" }]);
});

export default router;
