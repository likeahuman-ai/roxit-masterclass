import { AbsoluteFill, interpolate, spring, useCurrentFrame, useVideoConfig } from "remotion";
import { colors } from "../theme";
import { StepIcon } from "./step-icon";

type Props = {
  number: string;
  title: string;
  subtitle: string;
  accent: string;
  icon: "docker" | "download" | "cursor";
};

export const StepScene: React.FC<Props> = ({ number, title, subtitle, accent, icon }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  const cardSpring = spring({ frame, fps, config: { damping: 16, stiffness: 80 } });
  const cardOpacity = interpolate(frame, [0, 14], [0, 1], { extrapolateRight: "clamp" });
  const titleOpacity = interpolate(frame, [10, 26], [0, 1], { extrapolateRight: "clamp" });
  const subOpacity = interpolate(frame, [20, 36], [0, 1], { extrapolateRight: "clamp" });
  const iconScale = spring({ frame: frame - 6, fps, config: { damping: 14, stiffness: 110 } });

  return (
    <AbsoluteFill
      style={{
        alignItems: "center",
        justifyContent: "center",
        padding: 96,
      }}
    >
      <div
        style={{
          display: "flex",
          alignItems: "center",
          gap: 80,
          padding: "72px 96px",
          background: `linear-gradient(180deg, ${colors.navyLight} 0%, ${colors.navy} 100%)`,
          borderRadius: 24,
          border: `1px solid rgba(255,248,231,0.08)`,
          boxShadow: "0 32px 80px rgba(0,0,0,0.35)",
          opacity: cardOpacity,
          transform: `translateY(${(1 - cardSpring) * 32}px)`,
        }}
      >
        <div
          style={{
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            transform: `scale(${iconScale})`,
          }}
        >
          <StepIcon kind={icon} accent={accent} />
        </div>

        <div style={{ display: "flex", flexDirection: "column", maxWidth: 820 }}>
          <div
            style={{
              fontSize: 20,
              fontWeight: 500,
              letterSpacing: "+2.4px",
              color: accent,
              textTransform: "uppercase",
              marginBottom: 16,
            }}
          >
            Step {number}
          </div>
          <div
            style={{
              fontSize: 64,
              fontWeight: 700,
              color: colors.cream,
              letterSpacing: "-1px",
              lineHeight: 1.05,
              opacity: titleOpacity,
            }}
          >
            {title}
          </div>
          <div
            style={{
              fontSize: 24,
              fontWeight: 400,
              color: colors.sand,
              fontFamily: "ui-monospace, SFMono-Regular, Menlo, monospace",
              marginTop: 24,
              opacity: subOpacity,
            }}
          >
            {subtitle}
          </div>
        </div>
      </div>
    </AbsoluteFill>
  );
};
