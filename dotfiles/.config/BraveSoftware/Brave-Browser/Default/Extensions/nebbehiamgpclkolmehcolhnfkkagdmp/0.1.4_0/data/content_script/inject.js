try {
  if (!window._SoundAdjustment) {
    window._SoundAdjustment = {};
    //
    window._SoundAdjustment.audio = [];
    window._SoundAdjustment.media = [];
    window._SoundAdjustment.action = function (target) {
      const metrics = window._SoundAdjustmentMetrics;
      //
      if (!target.audiocontext) {
        try {
          target.crossOrigin = "anonymous";
          target.audiocontext = new AudioContext();
          //
          target.listener = target.audiocontext.listener;
          target.gainnode = target.audiocontext.createGain();
          target.panner = target.audiocontext.createPanner();
          target.stereo = target.audiocontext.createStereoPanner();
          target.source = target.audiocontext.createMediaElementSource(target);
          //
          target.source.connect(target.gainnode);
          target.gainnode.connect(target.stereo);
          target.stereo.connect(target.panner);
          target.panner.connect(target.audiocontext.destination);
          //
          if (target.audiocontext.state === "suspended") {
            const resume = function () {
              target.audiocontext.resume();
              //
              window.removeEventListener("click", resume);
              window.removeEventListener("keydown", resume);
            };
            //
            window.addEventListener("click", resume);
            window.addEventListener("keydown", resume);
          }
        } catch (e) {
          //console.error(e);
        }
      }
      //
      if (metrics) {
        let volume = "volume" in metrics ? Number(metrics.volume) : undefined;
        let balance = "balance" in metrics ? Number(metrics.balance) : undefined;
        let amplify = "amplify" in metrics ? Number(metrics.amplify) : undefined;
        let positionX = "positionX" in metrics ? Number(metrics.positionX) : undefined;
        let positionY = "positionY" in metrics ? Number(metrics.positionY) : undefined;
        let positionZ = "positionZ" in metrics ? Number(metrics.positionZ) : undefined;
        //
        if (balance !== undefined) {
          target.stereo.pan.value = balance;
        }
        //
        if (volume !== undefined) {
          target.gainnode.gain.value = amplify !== undefined ? volume * amplify : volume;
        }
        //
        if (metrics.listener === true) {
          if (positionX !== undefined) {
            target.panner.positionX.value = 0;
            target.listener.positionX.value = positionX;
          }
          //
          if (positionY !== undefined) {
            target.panner.positionY.value = 0;
            target.listener.positionY.value = positionY;
          }
          //
          if (positionZ !== undefined) {
            target.panner.positionZ.value = 0;
            target.listener.positionZ.value = positionZ;
          }
        }
        //
        if (metrics.panner === true) {
          if (positionX !== undefined) {
            target.listener.positionX.value = 0;
            target.panner.positionX.value = positionX;
          }
          //
          if (positionY !== undefined) {
            target.listener.positionY.value = 0;
            target.panner.positionY.value = positionY;
          }
          //
          if (positionZ !== undefined) {
            target.listener.positionZ.value = 0;
            target.panner.positionZ.value = positionZ;
          }
        }
      }
    }
    //
    window.Audio = new Proxy(window.Audio, {
      construct(target, args, newTarget) {
        const result = Reflect.construct(target, args, newTarget);
        window._SoundAdjustment.audio.push(result);
        window._SoundAdjustment.action(result);
        //
        return result;
      }
    });
  }
} catch (e) {
  //console.error(e);
}

{
  window._SoundAdjustment.media = [...document.querySelectorAll("video, audio")];
  //
  var array = [...window._SoundAdjustment.audio, ...window._SoundAdjustment.media];
  if (array.length) {
    for (let i = 0; i < array.length; i++) {
      const target = array[i];
      window._SoundAdjustment.action(target);
    }
  }
}
