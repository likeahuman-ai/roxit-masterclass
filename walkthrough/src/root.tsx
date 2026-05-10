import { Composition } from "remotion";
import { Walkthrough } from "./walkthrough";

export const Root: React.FC = () => {
  return (
    <Composition
      id="Walkthrough"
      component={Walkthrough}
      durationInFrames={900}
      fps={30}
      width={1920}
      height={1080}
    />
  );
};
