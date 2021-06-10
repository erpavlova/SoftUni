function attachGradientEvents() {

    document.getElementById('gradient').addEventListener('mousemove', onMove);
    const result = document.getElementById('result');

    function onMove(event) {
        const offsetX = event.offsetX;
        const percent = Math.floor(offsetX / event.target.clientWidth * 100);

        result.textContent = `${percent}%`;

    }
}