import { ViewHook } from "phoenix_live_view";

export class Universe extends ViewHook {
  canvas() {
    return this.el;
  }
  ctx() {
    return this.canvas().getContext("2d");
  }
  cells() {
    return JSON.parse(this.el.dataset.cells);
  }
  baseCellSize() {
    return 20 * this.ratio();
  }
  ratio() {
    return window.devicePixelRatio || 1;
  }
  mounted() {
    this.scaleCanvas();
    this.renderCells();

    addEventListener("resize", (event) => {
      this.scaleCanvas();
      this.renderCells();
    });
  }
  updated() {
    if (this.animationFrameRequest) {
      cancelAnimationFrame(this.animationFrameRequest);
    }
    this.animationFrameRequest = requestAnimationFrame(() => this.renderCells());
  }
  scaleCanvas() {
    // Shout out this gist:
    // https://gist.github.com/callumlocke/cc258a193839691f60dd
    const canvas = this.canvas();
    const ctx = this.ctx();
    const ratio = this.ratio();

    canvas.width = window.innerWidth * ratio;
    canvas.height = window.innerHeight * ratio;
    canvas.style.width = `${window.innerWidth}px`;
    canvas.style.height = `${window.innerHeight}px`;

    const centerX = canvas.width / 2;
    const centerY = canvas.height / 2;

    ctx.translate(centerX, centerY);
    ctx.scale(ratio, ratio);
  }
  renderCells() {
    const canvas = this.canvas();
    const ctx = this.ctx();
    const cells = this.cells();
    const ratio = this.ratio();
    const baseCellSize = this.baseCellSize();

    this.clearCanvas();
    ctx.save();
    // --color-success
    ctx.fillStyle = "rgb(105.06, 254.08, 195.35";

    // Calculate initial co-ordinates so that universe is centered on screen.
    const initialX = -1 * baseCellSize * (this.el.dataset.xSize / 2);
    const initialY = -1 * baseCellSize * (this.el.dataset.ySize / 2);

    for (let i = 0; i < cells.length; i++) {
      for (let j = 0; j < cells[i].length; j++) {
        let cell = cells[i][j];

        if (cells[i][j] === 0) {
          continue;
        }

        const x = initialX + baseCellSize * j;
        const y = initialY + baseCellSize * i;

        ctx.fillRect(x, y, baseCellSize, baseCellSize);
      }
    }
    ctx.restore();
  }
  clearCanvas() {
    this.ctx().clearRect(
      -this.canvas().width,
      -this.canvas().height,
      this.el.width * this.ratio(),
      this.el.height * this.ratio(),
    );
  }
}
