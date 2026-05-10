import { AbsoluteFill, Sequence } from "remotion";
import { loadFont } from "@remotion/google-fonts/Montserrat";
import { TitleScene } from "./scenes/title-scene";

loadFont("normal", { weights: ["400", "500", "600", "700", "800"] });
import { StepScene } from "./scenes/step-scene";
import { TerminalScene } from "./scenes/terminal-scene";
import { OutroScene } from "./scenes/outro-scene";
import { colors, font } from "./theme";

export const Walkthrough: React.FC = () => {
  return (
    <AbsoluteFill
      style={{
        background: `linear-gradient(165deg, ${colors.navy} 0%, ${colors.navyDeep} 100%)`,
        fontFamily: font.family,
      }}
    >
      <Sequence from={0} durationInFrames={120}>
        <TitleScene />
      </Sequence>

      <Sequence from={120} durationInFrames={150}>
        <StepScene
          number="01"
          title="Install Docker Desktop"
          subtitle="docker.com/products/docker-desktop"
          accent={colors.blue}
          icon="docker"
        />
      </Sequence>

      <Sequence from={270} durationInFrames={150}>
        <StepScene
          number="02"
          title="Download the workshop zip"
          subtitle="github.com/likeahuman-ai/roxit-masterclass"
          accent={colors.gold}
          icon="download"
        />
      </Sequence>

      <Sequence from={420} durationInFrames={150}>
        <StepScene
          number="03"
          title="Double-click the launcher"
          subtitle="Roxit.command  ·  Roxit.bat  ·  Roxit.sh"
          accent={colors.lime}
          icon="cursor"
        />
      </Sequence>

      <Sequence from={570} durationInFrames={210}>
        <TerminalScene />
      </Sequence>

      <Sequence from={780} durationInFrames={120}>
        <OutroScene />
      </Sequence>
    </AbsoluteFill>
  );
};
