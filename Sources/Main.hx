package;

import kha.math.Vector2;
import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Main {
	static var logos: Array<Logo> = new Array<Logo>();

	static function update(): Void {
		for (logo in logos) logo.update();
	}

	static function render(frames: Array<Framebuffer>): Void {
		final fb = frames[0];
		final g2 = fb.g2;
		g2.begin(kha.Color.Black);
		for (logo in logos) logo.render(g2);
		g2.end();
	}

	public static function main() {
		System.start({title: "Project", width: 900, height: 500}, function (_) {
			// Just loading everything is ok for small projects
			Assets.loadEverything(function () {
				// Avoid passing update/render directly,
				// so replacing them via code injection works
				Scheduler.addTimeTask(function () { update(); }, 0, 1 / 60);
				System.notifyOnFrames(function (frames) { render(frames); });
				logos.push(new Logo());
			});
		});
	}
}

class Logo {
	var position: Vector2;
	var velocity: Vector2;
	public static inline var squareSize = 50; 

	public function new() {
		position = new Vector2(squareSize / 2, squareSize / 2);
		velocity = new Vector2(3, 3);
	}

	public function render(g:kha.graphics2.Graphics): Void {
		var keys = kha.Assets.images.dvd;

		g.color = kha.Color.Purple;
		g.drawScaledImage(keys, position.x, position.y, 200, 100);
	}

	public function getArbitrary(min: Float, max: Float):Float {
		return Math.random() * (max - min) + min;
	}

	public function update(): Void {
		position.x += velocity.x;
		position.y += velocity.y;

		if(position.x > 900 - 200 || position.x < 0) {
			velocity.x *= -1;
		}

		if(position.y > 500 - 100 || position.y < 0) {
			velocity.y *= -1;
		}
	}
}