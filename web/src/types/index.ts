export interface FloorData {
    id: number;
    name: string;
    icon?: string;
    current: boolean;
    accessible: boolean;
}

export type AccessStatus = 'standby' | 'authorised' | 'denied';

export interface ElevatorData {
    restricted: boolean;
    access?: AccessStatus;
    floors: FloorData[];
}
