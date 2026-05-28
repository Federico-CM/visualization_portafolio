"""Create a Japanese data-analysis Daruma infographic image."""

from dataclasses import dataclass

from PIL import Image, ImageDraw, ImageFont


IMAGE_PATH = "daruma.png"
OUTPUT_PATH = "daruma_infographic.png"
FONT_PATH = "keifont.ttf"

TITLE_COLOR = "#122c5e"
LABEL_BOX_COLOR = "#f3e5d0"
LABEL_TEXT_COLOR = "#f28c28"

TITLE_TEXT = "データ分析からキーワード"
SUBTITLE_LINES = (
    "少数のキーワードが、全体を支配する",
    "情報の80％は、25％の言葉に",
)

LABELS = (
    ("収集", (310, 632), "#f3e5d0", "#f28c28"),
    ("処理", (450, 657), "#f3e5d0", "#f28c28"),
    ("探索", (590, 682), "#e3d1fe", "#4a1f7e"),
    ("検証", (745, 695), "#e3d1fe", "#4a1f7e"),
    ("理解", (890, 682), "#e3d1fe", "#4a1f7e"),
    ("発表", (1040, 657), "#c9d8f3", "#11285a"),
    ("洞察", (1182, 632), "#c9d8f3", "#11285a"),
)

KEYWORD_GROUPS = (
    ((273, 686), ("取得する", "抽出する", "集計する", "情報")),
    ((418, 711), ("欠損値", "重複", "補完", "修正")),
    ((586, 736), ("傾向", "推移", "増加", "相関")),
    ((734, 751), ("確認する", "異常", "検出", "正確")),
    ((900, 736), ("把握する", "分かる", "原因", "結果")),
    ((1045, 710), ("グラフ", "示す", "表す", "報告")),
    ((1200, 686), ("結論", "戦略", "予測", "需要")),
)


@dataclass(frozen=True)
class Fonts:
    """Fonts used by the infographic."""

    title: ImageFont.FreeTypeFont
    subtitle: ImageFont.FreeTypeFont
    label: ImageFont.FreeTypeFont
    keyword: ImageFont.FreeTypeFont


@dataclass(frozen=True)
class LabelStyle:
    """Style settings for a rounded text label."""

    text_fill: str
    box_fill: str
    padding: tuple[int, int] = (7, 6)
    radius: int = 15


def draw_text_block(
    canvas: ImageDraw.ImageDraw,
    position: tuple[int, int],
    text: str,
    font: ImageFont.FreeTypeFont,
    fill: str,
) -> tuple[int, int, int, int]:
    """Draw text and return its bounding box."""

    canvas.text(position, text, font=font, fill=fill)
    return canvas.textbbox(position, text, font=font)


def draw_label(
    canvas: ImageDraw.ImageDraw,
    text: str,
    position: tuple[int, int],
    font: ImageFont.FreeTypeFont,
    style: LabelStyle,
) -> list[int]:
    """Draw a rounded label and return its rectangle coordinates."""

    x_pos, y_pos = position
    pad_x, pad_y = style.padding
    bbox = canvas.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    rectangle = [
        x_pos,
        y_pos,
        x_pos + text_width + pad_x * 2,
        y_pos + text_height + pad_y * 2,
    ]

    canvas.rounded_rectangle(rectangle, radius=style.radius, fill=style.box_fill)
    canvas.text(
        (x_pos + pad_x, y_pos + pad_y),
        text,
        font=font,
        fill=style.text_fill,
    )
    return rectangle


def load_fonts(font_path: str) -> Fonts:
    """Load all fonts used by the image."""

    return Fonts(
        title=ImageFont.truetype(font_path, size=70),
        subtitle=ImageFont.truetype(font_path, size=35),
        label=ImageFont.truetype(font_path, size=32),
        keyword=ImageFont.truetype(font_path, size=28),
    )


def draw_header(canvas: ImageDraw.ImageDraw, fonts: Fonts) -> None:
    """Draw the title and subtitle text."""

    title_position = (20, 30)
    title_bbox = draw_text_block(
        canvas,
        title_position,
        TITLE_TEXT,
        fonts.title,
        TITLE_COLOR,
    )

    subtitle_position = (title_position[0], title_bbox[3] + 10)
    for subtitle in SUBTITLE_LINES:
        subtitle_bbox = draw_text_block(
            canvas,
            subtitle_position,
            subtitle,
            fonts.subtitle,
            TITLE_COLOR,
        )
        subtitle_position = (subtitle_position[0], subtitle_bbox[3] + 5)


def draw_labels(canvas: ImageDraw.ImageDraw, fonts: Fonts) -> None:
    """Draw all category labels."""

    for text, position, box_fill, text_fill in LABELS:
        draw_label(
            canvas,
            text,
            position,
            fonts.label,
            LabelStyle(text_fill=text_fill, box_fill=box_fill),
        )


def draw_keywords(canvas: ImageDraw.ImageDraw, fonts: Fonts) -> None:
    """Draw the keyword groups under each label."""

    line_spacing = 34
    for (x_pos, y_pos), keywords in KEYWORD_GROUPS:
        for line_number, keyword in enumerate(keywords):
            draw_text_block(
                canvas,
                (x_pos, y_pos + line_number * line_spacing),
                keyword,
                fonts.keyword,
                TITLE_COLOR,
            )


def create_infographic(
    image_path: str = IMAGE_PATH,
    output_path: str = OUTPUT_PATH,
    font_path: str = FONT_PATH,
) -> None:
    """Create the infographic and save it to disk."""

    image = Image.open(image_path).convert("RGBA")
    canvas = ImageDraw.Draw(image)
    fonts = load_fonts(font_path)

    draw_header(canvas, fonts)
    draw_labels(canvas, fonts)
    draw_keywords(canvas, fonts)

    image.save(output_path)


if __name__ == "__main__":
    create_infographic()
    