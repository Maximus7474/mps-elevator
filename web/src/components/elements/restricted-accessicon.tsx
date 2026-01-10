import React from "react";
import "../App.css";
import { AccessStatus } from "../../types";

interface KeyHoleProps {
    restricted: boolean,
    accessState: AccessStatus;
}

type statusColour = 'yellow' | 'green' | 'red' | 'lightgrey';

const KeyHole: React.FC<KeyHoleProps> = ({ restricted, accessState }) => {
    if (!restricted) return null;

    const statusColor: statusColour = (
        accessState === 'standby'
            ? 'yellow'
            : accessState === 'authorised'
                ? 'green'
                : accessState === 'denied'
                    ? 'red'
                    : 'lightgrey'
    );

    return (
        <div style={{ textAlign: 'center',paddingTop: '1em' }}>
            <svg
                width="125"
                height="125"
                viewBox="0 0 150 150"  // Adjusted viewBox to fit the entire content
                xmlns="http://www.w3.org/2000/svg"
            >
                <defs>
                    <filter id="shadow" x="0" y="0">
                        <feDropShadow dx="4" dy="4" stdDeviation="4" floodColor="rgba(0, 0, 0, 0.5)" />
                    </filter>
                    <radialGradient id="grad1" cx="50%" cy="50%" r="50%" fx="50%" fy="50%">
                        <stop offset="80%" style={{ stopColor: "#000", stopOpacity: 1 }} />
                        <stop offset="90%" style={{ stopColor: "#333", stopOpacity: 1 }} />
                        <stop offset="0%" style={{ stopColor: "#222", stopOpacity: 1 }} />
                    </radialGradient>
                </defs>
                <circle
                    cx="75"
                    cy="75"
                    r="60"
                    fill="url(#grad1)"
                    stroke="#000"
                    strokeWidth="0"
                    filter="url(#shadow)"
                />
                <rect
                    x="60"
                    y="30"
                    width="30"
                    height="5"
                    ry="5"
                    fill={statusColor}
                    className={`status-light ${statusColor === 'red' ? 'pulse' : ''}`}
                />
                <g transform="translate(21, 38) scale(0.30)">
                    <g transform="translate(0,360) scale(0.1,-0.1)" fill="#ffffff" stroke="none">
                        <path d="M1008 2943 c-107 -115 -177 -247 -224 -423 -27 -99 -25 -348 4 -453 43 -157 139 -325 236 -415 51 -47 75 -49 109 -10 26 31 21 52 -29 110 -95 112 -146 206 -187 346 -30 106 -29 302 1 415 29 106 100 238 172 321 65 75 73 103 40 136 -34 34 -72 26 -122 -27z" />
                        <path d="M2470 2970 c-32 -32 -24 -60 40 -135 73 -85 143 -217 172 -322 30 -113 31 -309 1 -415 -41 -140 -92 -234 -187 -346 -50 -58 -55 -79 -28 -110 33 -39 57 -37 108 10 97 90 193 258 236 415 29 105 31 354 4 453 -47 176 -117 308 -224 423 -50 53 -88 61 -122 27z" />
                        <path d="M1276 2728 c-209 -239 -205 -634 9 -855 56 -58 83 -65 115 -33 32 32 25 65 -27 128 -163 200 -162 479 2 670 49 59 58 97 27 125 -10 10 -32 17 -50 17 -24 0 -40 -10 -76 -52z" />
                        <path d="M2197 2762 c-29 -31 -20 -66 28 -124 164 -191 164 -471 2 -670 -52 -63 -59 -96 -27 -128 32 -32 59 -25 115 33 133 138 193 366 150 572 -19 90 -81 215 -140 283 -38 43 -52 52 -79 52 -19 0 -40 -8 -49 -18z" />
                        <path d="M1747 2559 c-127 -30 -207 -128 -207 -254 0 -100 55 -190 145 -238 56 -30 174 -30 230 0 157 84 193 282 76 415 -53 60 -166 96 -244 77z" />
                    </g>
                </g>
            </svg>
        </div>
    );
}

export default KeyHole;
