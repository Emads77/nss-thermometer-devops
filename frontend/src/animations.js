import { gsap } from "gsap";
import confetti from "canvas-confetti";

/**
 * Create the call to action screen animation.
 * @returns animation object with play/pause method.
 */
export function createAnimationCallToActionScreen() {
  const tl = gsap.timeline({
    defaults: { duration: 1, ease: "power2.out" },
    paused: true,
  });

  tl.fromTo(
    "#call-to-action-screen h1",
    { opacity: 0, y: 50 },
    { opacity: 1, y: 0, stagger: 0.5, delay: 0 }
  );

  const result = {
    play: () => tl.play(),
    reset: () => tl.pause(0),
  };

  return result;
}

/**
 * Create the percentage bar screen animation.
 * @returns animation object with play/pause method.
 */
export function createAnimationPercentageBarScreen(percentage) {
  let tl = gsap.timeline({ defaults: { ease: "power2.out" }, paused: true });

  tl.fromTo(
    "#percentage-bar-screen h1",
    { opacity: 0, y: 50 },
    { opacity: 1, y: 0, stagger: 0.5, delay: 0, duration: 1 }
  );

  tl.fromTo(
    ".percentage-bar-container",
    { opacity: 0, y: 50 },
    { opacity: 1, y: 0, stagger: 0.5, delay: -0.5, duration: 1 }
  );

  tl.fromTo(
    "#percentage-bar",
    { width: "0%" },
    {
      width: percentage + "%",
      duration: 2,
      delay: 0.5,
      onUpdate: function () {
        document.querySelector("#percentage-bar .percentage-text").innerText =
          Math.round(this.progress() * percentage) + "%";
      },
    }
  );

  const result = {
    play: () => tl.play(),
    reset: () => {
      tl.pause(0);
      // Reset percentage bar
      document.querySelector("#percentage-bar .percentage-text").innerText =
        "0%";
    },
  };

  return result;
}

/**
 * Create the animation goal screen.
 * @returns animation object with play/pause method.
 */
export function createAnimationGoalScreen() {
  let tl = gsap.timeline({ defaults: { ease: "power2.out" }, paused: true });

  tl.fromTo(
    "#goal-screen h1",
    { opacity: 0, y: 50 },
    { opacity: 1, y: 0, stagger: 0.5, delay: 0, duration: 1 }
  );

  const cards = document.querySelectorAll(".card");
  if (cards.length > 0) {
    tl.fromTo(
      ".card",
      {
        opacity: 0,
        y: 50,
      },
      {
        opacity: 1,
        y: 0,
        duration: 0.3,
        stagger: 0.2,
        delay: 0,
        onComplete: launchConfetti,
      }
    );
  } else {
    console.warn("No goals were found, so there will not be a goal card animation!");
  }

  const result = {
    play: () => tl.play(),
    reset: () => tl.pause(0),
  };

  return result;
}

/**
 * Function for the launching a small bit of confetti.
 * @param {} particleRatio
 * @param {*} opts
 */
function fire(particleRatio, opts) {
  const count = 200;
  const defaults = {
    origin: { y: 0.8 },
  };
  confetti({
    ...defaults,
    ...opts,
    particleCount: Math.floor(count * particleRatio),
  });
}

/**
 * Function to launch the complex confetti animation.
 */
export function launchConfetti() {
  fire(0.25, { spread: 26, startVelocity: 55 });
  fire(0.2, { spread: 60 });
  fire(0.35, { spread: 100, decay: 0.91, scalar: 0.8 });
  fire(0.1, { spread: 120, startVelocity: 25, decay: 0.92, scalar: 1.2 });
  fire(0.1, { spread: 120, startVelocity: 45 });
}
