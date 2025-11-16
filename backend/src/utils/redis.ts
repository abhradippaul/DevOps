import { createClient } from "redis";

const REDIS_URL = process.env.REDIS_URL || "";

export const client = createClient({ url: REDIS_URL });

client.on("error", (err) => console.error("Redis Client Error", err));

export async function getValueFromRedis(key: string) {
  return await client.get(key);
}

export async function setValueInRedis(key: string, value: string) {
  return await client.set(key, value);
}
