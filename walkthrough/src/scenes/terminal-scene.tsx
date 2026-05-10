import { AbsoluteFill, interpolate, spring, useCurrentFrame, useVideoConfig } from "remotion";
import { colors } from "../theme";

const LINES: { text: string; color: string; delay: number }[] = [
  { text: "$ claude", color: colors.lime, delay: 0 },
  { text: "  Opening browser to authorize...", color: colors.textMuted, delay: 18 },
  { text: "  Paste the code from the browser:", color: colors.textMuted, delay: 36 },
  { text: "  > ●●●●●●●●●●●●", color: colors.cream, delay: 54 },
  { text: "  Logged in as info@staats.dev", color: colors.green, delay: 72 },
  { text: "", color: colors.cream, delay: 84 },
  { text: "> Wat staat er in deze workspace?", color: colors.gold, delay: 96 },
];

export const TerminalScene: React.FC = () => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  const enter = spring({ frame, fps, config: { damping: 16, stiffness: 80 } });
  const opacity = interpolate(frame, [0, 14], [0, 1], { extrapolateRight: "clamp" });

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
          width: 1400,
          background: "#08182E",
          borderRadius: 16,
          border: `1px solid rgba(255,248,231,0.10)`,
          boxShadow: "0 40px 100px rgba(0,0,0,0.5)",
          overflow: "hidden",
          opacity,
          transform: `translateY(${(1 - enter) * 28}px)`,
        }}
      >
        <TerminalChrome />
        <div
          style={{
            padding: "40px 56px 56px 56px",
            fontFamily: "ui-monospace, SFMono-Regular, Menlo, monospace",
            fontSize: 28,
            lineHeight: 1.6,
            minHeight: 520,
          }}
        >
          {LINES.map((line, i) => {
            const lineOpacity = interpolate(
              frame,
              [line.delay, line.delay + 8],
              [0, 1],
              { extrapolateLeft: "clamp", extrapolateRight: "clamp" }
            );
            const isPrompt = i === 0 || line.text.startsWith(">");
            return (
              <div
                key={i}
                style={{
                  color: line.color,
                  opacity: lineOpacity,
                  fontWeight: isPrompt ? 600 : 400,
                  whiteSpace: "pre",
                }}
              >
                {line.text || " "}
              </div>
            );
          })}
          <Cursor delay={108} />
        </div>
      </div>
    </AbsoluteFill>
  );
};

const TerminalChrome: React.FC = () => {
  return (
    <div
      style={{
        height: 44,
        background: colors.navyDeep,
        display: "flex",
        alignItems: "center",
        gap: 8,
        padding: "0 20px",
        borderBottom: `1px solid rgba(255,248,231,0.06)`,
      }}
    >
      <div style={{ width: 12, height: 12, borderRadius: "50%", background: "#FF5F57" }} />
      <div style={{ width: 12, height: 12, borderRadius: "50%", background: "#FEBC2E" }} />
      <div style={{ width: 12, height: 12, borderRadius: "50%", background: "#28C840" }} />
      <div
        style={{
          marginLeft: 24,
          fontSize: 16,
          color: colors.textMuted,
          fontWeight: 500,
          letterSpacing: "+0.4px",
        }}
      >
        roxit-masterclass · /workspace
      </div>
    </div>
  );
};

const Cursor: React.FC<{ delay: number }> = ({ delay }) => {
  const frame = useCurrentFrame();
  if (frame < delay) return null;
  const blink = Math.floor((frame - delay) / 15) % 2 === 0;
  return (
    <span
      style={{
        display: "inline-block",
        width: 14,
        height: 28,
        background: colors.cream,
        marginLeft: 4,
        verticalAlign: "middle",
        opacity: blink ? 1 : 0,
      }}
    />
  );
};
