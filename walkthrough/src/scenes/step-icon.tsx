import { colors } from "../theme";

type Props = {
  kind: "docker" | "download" | "cursor";
  accent: string;
};

const SIZE = 200;

export const StepIcon: React.FC<Props> = ({ kind, accent }) => {
  return (
    <div
      style={{
        width: SIZE,
        height: SIZE,
        borderRadius: 32,
        background: `linear-gradient(180deg, ${colors.navyDeep} 0%, #08182E 100%)`,
        border: `1px solid rgba(255,248,231,0.10)`,
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
      }}
    >
      {kind === "docker" && <DockerGlyph accent={accent} />}
      {kind === "download" && <DownloadGlyph accent={accent} />}
      {kind === "cursor" && <CursorGlyph accent={accent} />}
    </div>
  );
};

const DockerGlyph: React.FC<{ accent: string }> = ({ accent }) => {
  return (
    <svg width="120" height="120" viewBox="0 0 24 24" fill="none">
      {[
        [3, 12], [7, 12], [11, 12], [15, 12],
        [7, 8], [11, 8], [15, 8],
        [11, 4],
      ].map(([x, y], i) => (
        <rect
          key={i}
          x={x}
          y={y}
          width={3.4}
          height={3.4}
          rx={0.5}
          fill={accent}
          opacity={0.85}
        />
      ))}
      <path
        d="M2 14 Q 4 18 10 18 L 18 18 Q 22 18 22 14"
        stroke={accent}
        strokeWidth={1.5}
        fill="none"
        strokeLinecap="round"
      />
    </svg>
  );
};

const DownloadGlyph: React.FC<{ accent: string }> = ({ accent }) => {
  return (
    <svg width="120" height="120" viewBox="0 0 24 24" fill="none" stroke={accent} strokeWidth={1.6} strokeLinecap="round" strokeLinejoin="round">
      <path d="M12 3 L 12 16" />
      <path d="M6 11 L 12 17 L 18 11" />
      <path d="M4 20 L 20 20" />
    </svg>
  );
};

const CursorGlyph: React.FC<{ accent: string }> = ({ accent }) => {
  return (
    <svg width="120" height="120" viewBox="0 0 24 24" fill="none">
      <path
        d="M5 3 L 5 18 L 9 14 L 12 21 L 14.5 19.8 L 11.5 13 L 17 13 Z"
        fill={accent}
        stroke={accent}
        strokeWidth={1}
        strokeLinejoin="round"
      />
    </svg>
  );
};
