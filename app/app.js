const log = document.querySelector('#log');
const status = document.querySelector('#status');
const clock = document.querySelector('#clock');
const tick = () => { clock.textContent = new Date().toLocaleTimeString(); };
tick();
setInterval(tick, 1000);

// Demo-only handler: produces sample output for the static control surface.
// It does NOT execute a real verification endpoint. Real evidence collection
// remains the responsibility of CI and the verify-repo.sh gate.
document.querySelector('#run').addEventListener('click', () => {
  status.textContent = 'DEMO';
  log.textContent =
    '$ ariex4ops verify  (sample / demo output only)\n' +
    '> structural contract ........ PASS (demo)\n' +
    '> shell syntax ............... PASS (demo)\n' +
    '> secret pattern gate ........ PASS (demo)\n' +
    '> Docker blueprint ........... PASS (demo)\n' +
    '> animation surface .......... PASS (demo)\n' +
    '> CI contract ................ PASS (demo)\n' +
    '> evidence status ............. SAMPLE\n\n' +
    '$ status: DEMO READY — not live evidence';
  setTimeout(() => { status.textContent = 'DEMO READY'; }, 900);
});
