import { Router } from "express";
import auth from "./auth";
import { AuthRequest } from "../middleware/auth";
import { NewTask, tasks } from "../db/schema";
import { db } from "../db";

const taskRouter = Router()

taskRouter.post("/", auth, async (req: AuthRequest, res) => {
  try {
    req.body = { ...req.body, dueAt: new Date(req.body.dueAt), uid: req.user };
    const newTask: NewTask = req.body;

    const [task] = await db.insert(tasks).values(newTask).returning();

    res.status(201).json(task);
  } catch (e) {
    console.log(e)
    console.log("updatedAt:", new Date().toISOString());
    res.status(500).json({ error: e });
  }
});

export default taskRouter;