export interface FloorData {
    id: number;
    name: string;
    icon?: string;
    current: boolean;
    accessible: boolean;
}

export interface ElevatorData {
    restricted: boolean;
    floors: FloorData[];
}

export type AccessStatus = 'standby' | 'authorised' | 'denied';
