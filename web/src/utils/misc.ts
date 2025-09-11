// Will return whether the current environment is in a regular browser

import { FloorData } from "../types";

// and not CEF
export const isEnvBrowser = (): boolean => !(window as any).invokeNative;

// Basic no operation function
export const noop = () => {};

export const formatFloorIcon = (floor: FloorData) => floor.icon ?? `${floor.id}`.padStart(2, "0");
