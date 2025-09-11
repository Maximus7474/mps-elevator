import React, { useState } from "react";
import "./App.css";
import { debugData } from "../utils/debugData";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";
import FloorView from "./elements/floor-view";
import FloorButton from "./elements/floor-button";
import AccessIcon from "./elements/restricted-accessicon";
import { AccessStatus, ElevatorData, FloorData } from "../types";
import { formatFloorIcon } from "../utils/misc";

debugData([
  {
    action: "SetElevatorData",
    data: {
      restricted: true,
      floors: [
        { id: 1, name: 'Garage', icon: 'G', accessible: true, current: true },
        { id: 2, name: 'Entrance', icon: '0', accessible: true, current: false },
        { id: 3, name: 'Helipad', icon: 'H', accessible: false, current: false },
      ],
    } as ElevatorData,
  },
]);

debugData([
  {
    action: "setVisible",
    data: true,
  },
]);

const App: React.FC = () => {

  const [currentFloor, setCurrentFloor] = useState<FloorData | "ERR" | null>(null);
  const [access, setAccess] = useState<AccessStatus>('standby');
  const [restrictedState, setRestrictedState] = useState<boolean>(false);
  const [floorButtons, setFloorButtons] = useState<FloorData[]>([]);

  useNuiEvent<ElevatorData>('SetElevatorData', ({ restricted, floors }) => {
    const currentFloor = floors.find((e) => e.current);

    if (!currentFloor || floors.length < 1) {
      setFloorButtons([]);
      setCurrentFloor('ERR');
      setAccess('denied');
      return;
    }
    
    setAccess('standby');
    setRestrictedState(restricted);
    setCurrentFloor(currentFloor);
    setFloorButtons(floors);
  });

  const handleButtonClick = (floor: FloorData) => {
    if (!floor.accessible) {
      setAccess('denied');
      return;
    }

    fetchNui<boolean>("SetNewFloor", { floorIndex: floor.id }, true)
      .then((accessible) => {
        if (accessible) {
          setAccess('authorised');
        } else {
          setAccess('denied');
        }
      })
      .catch((e) => {
        console.error('An error occured:', e);
        setCurrentFloor("ERR");
        setAccess('denied');
      });
  };

  return (
    <div className="nui-wrapper">
      <div className="elevator-panel">
        <FloorView floor={currentFloor} />
        <div className="button-grid">
          {
            floorButtons.map((floor) => (
              <FloorButton key={floor.id} floor={formatFloorIcon(floor)} label={floor.name} onClick={() => handleButtonClick(floor)} />
            ))
          }
        </div>
        <AccessIcon restricted={restrictedState} accessState={access} />
      </div>
    </div>
  );
};

export default App;
