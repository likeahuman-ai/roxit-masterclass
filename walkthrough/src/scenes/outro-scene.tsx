import { AbsoluteFill, interpolate, spring, useCurrentFrame, useVideoConfig } from "remotion";
import { colors } from "../theme";

export const OutroScene: React.FC = () => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  const enter = spring({ frame, fps, config: { damping: 16, stiffness: 90 } });
  const titleOpacity = interpolate(frame, [0, 14], [0, 1], { extrapolateRight: "clamp" });
  const subOpacity = interpolate(frame, [16, 32], [0, 1], { extrapolateRight: "clamp" });
  const lineWidth = interpolate(frame, [24, 56], [0, 320], { extrapolateRight: "clamp" });

  return (
    <AbsoluteFill
      style={{
        alignItems: "center",
        justifyContent: "center",
        textAlign: "center",
      }}
    >
      <div
        style={{
          fontSize: 88,
          fontWeight: 700,
          color: colors.cream,
          letterSpacing: "-1.2px",
          opacity: titleOpacity,
          transform: `translateY(${(1 - enter) * 24}px)`,
        }}
      >
        You're ready to build.
      </div>

      <div
        style={{
          width: lineWidth,
          height: 3,
          background: colors.gold,
          marginTop: 40,
          marginBottom: 32,
          borderRadius: 2,
        }}
      />

      <div
        style={{
          fontSize: 24,
          fontWeight: 500,
          letterSpacing: "+2.4px",
          color: colors.gold,
          textTransform: "uppercase",
          opacity: subOpacity,
        }}
      >
        Built by Like a Human · Amsterdam
      </div>
    </AbsoluteFill>
  );
};
