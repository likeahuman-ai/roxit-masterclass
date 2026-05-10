import { AbsoluteFill, interpolate, spring, useCurrentFrame, useVideoConfig } from "remotion";
import { colors } from "../theme";

export const TitleScene: React.FC = () => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  const titleY = spring({ frame, fps, config: { damping: 18, stiffness: 90, mass: 0.6 } });
  const titleOpacity = interpolate(frame, [0, 12], [0, 1], { extrapolateRight: "clamp" });
  const subOpacity = interpolate(frame, [18, 32], [0, 1], { extrapolateRight: "clamp" });
  const eyebrowOpacity = interpolate(frame, [0, 10], [0, 1], { extrapolateRight: "clamp" });
  const lineWidth = interpolate(frame, [25, 55], [0, 320], {
    extrapolateLeft: "clamp",
    extrapolateRight: "clamp",
  });

  return (
    <AbsoluteFill
      style={{
        alignItems: "center",
        justifyContent: "center",
        textAlign: "center",
        padding: 64,
      }}
    >
      <div
        style={{
          fontSize: 20,
          fontWeight: 500,
          letterSpacing: "+2.4px",
          color: colors.gold,
          textTransform: "uppercase",
          opacity: eyebrowOpacity,
          marginBottom: 32,
        }}
      >
        Roxit Masterclass · AI Experience Week
      </div>

      <div
        style={{
          fontSize: 96,
          fontWeight: 700,
          color: colors.cream,
          letterSpacing: "-1.4px",
          lineHeight: 1.05,
          opacity: titleOpacity,
          transform: `translateY(${(1 - titleY) * 24}px)`,
        }}
      >
        One-click Claude Code sandbox
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
          fontSize: 28,
          fontWeight: 400,
          color: colors.sand,
          opacity: subOpacity,
          maxWidth: 880,
        }}
      >
        Setup in four steps. No Node install, no git config, no friction.
      </div>
    </AbsoluteFill>
  );
};
