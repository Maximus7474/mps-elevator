import React from "react";
import "../App.css";
import { type FloorData } from "../../types";
import { formatFloorIcon } from "../../utils/misc";

interface FloorViewProps {
    floor: FloorData | "ERR" | null;
}

const FloorView: React.FC<FloorViewProps> = ({ floor }) => {
    const paddedFloor = typeof floor === "string"
        ? floor
        : floor && typeof floor === 'object'
            ? formatFloorIcon(floor)
            : '00';
    
    const isError = paddedFloor === 'ERR';

    return (
        <div className="floor-indicator" style={isError ? { color: "red" } : {}}>
            {paddedFloor}
        </div>
    );
}

export default FloorView;
