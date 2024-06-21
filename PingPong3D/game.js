let scene, camera, renderer;
let playerPaddle, computerPaddle, ball, plane, borders;
let playerSpeed = 0, ballSpeed = new THREE.Vector3(0.05, 0.05, 0);
let playerScore = 0, computerScore = 0;
const scoreElement = document.getElementById('score');
let raycaster = new THREE.Raycaster();
let mouse = new THREE.Vector2();
let buttonUp, buttonDown, buttonUpText, buttonDownText;
let fontLoader = new THREE.FontLoader();
let gsapScriptLoaded = false;

init();
animate();

function init() {
    // Load GSAP for animations
    const script = document.createElement('script');
    script.src = 'https://cdnjs.cloudflare.com/ajax/libs/gsap/3.9.1/gsap.min.js';
    script.onload = () => {
        gsapScriptLoaded = true;
    };
    document.head.appendChild(script);

    // Scene
    scene = new THREE.Scene();
    scene.background = new THREE.Color(0x000000);

    // Camera
    camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    camera.position.z = 5;

    // Renderer
    renderer = new THREE.WebGLRenderer();
    renderer.setSize(window.innerWidth, window.innerHeight);
    document.body.appendChild(renderer.domElement);

    // Texture Loader
    const textureLoader = new THREE.TextureLoader();
    const paddleTexture = textureLoader.load('https://threejs.org/examples/textures/crate.gif');
    const ballTexture = textureLoader.load('https://threejs.org/examples/textures/planets/earth_atmos_2048.jpg');
    const backgroundTexture = textureLoader.load('https://threejs.org/examples/textures/planets/earth_atmos_2048.jpg');
    const borderTexture = textureLoader.load('https://threejs.org/examples/textures/brick_diffuse.jpg');
    const buttonTexture = textureLoader.load('https://threejs.org/examples/textures/terrain/grasslight-big.jpg');

    // Player Paddle
    let geometry = new THREE.BoxGeometry(0.2, 1, 0.2);
    let material = new THREE.MeshBasicMaterial({ map: paddleTexture });
    playerPaddle = new THREE.Mesh(geometry, material);
    playerPaddle.position.set(-3.5, 0, 0);
    scene.add(playerPaddle);

    // Computer Paddle
    computerPaddle = new THREE.Mesh(geometry, material);
    computerPaddle.position.set(3.5, 0, 0);
    scene.add(computerPaddle);

    // Ball
    geometry = new THREE.SphereGeometry(0.1, 32, 32);
    material = new THREE.MeshBasicMaterial({ map: ballTexture });
    ball = new THREE.Mesh(geometry, material);
    scene.add(ball);

    // Background Plane
    geometry = new THREE.PlaneGeometry(8, 5);
    material = new THREE.MeshBasicMaterial({ map: backgroundTexture, side: THREE.DoubleSide });
    plane = new THREE.Mesh(geometry, material);
    plane.position.z = -1;
    scene.add(plane);

    // Borders
    borders = new THREE.Group();
    const borderMaterial = new THREE.MeshBasicMaterial({ map: borderTexture });
    const borderThickness = 0.1;

    // Top border
    geometry = new THREE.BoxGeometry(8, borderThickness, 0.1);
    let topBorder = new THREE.Mesh(geometry, borderMaterial);
    topBorder.position.set(0, 2.6, 0);
    borders.add(topBorder);

    // Bottom border
    let bottomBorder = new THREE.Mesh(geometry, borderMaterial);
    bottomBorder.position.set(0, -2.6, 0);
    borders.add(bottomBorder);

    // Left border
    geometry = new THREE.BoxGeometry(borderThickness, 5.2, 0.1);
    let leftBorder = new THREE.Mesh(geometry, borderMaterial);
    leftBorder.position.set(-4.1, 0, 0);
    borders.add(leftBorder);

    // Right border
    let rightBorder = new THREE.Mesh(geometry, borderMaterial);
    rightBorder.position.set(4.1, 0, 0);
    borders.add(rightBorder);

    scene.add(borders);

    // Add 3D buttons
    const buttonGeometry = new THREE.BoxGeometry(1, 0.5, 0.1);
    const buttonMaterial = new THREE.MeshBasicMaterial({ map: buttonTexture });

    buttonUp = new THREE.Mesh(buttonGeometry, buttonMaterial);
    buttonUp.position.set(-1, -2.5, 0.5);
    scene.add(buttonUp);

    buttonDown = new THREE.Mesh(buttonGeometry, buttonMaterial);
    buttonDown.position.set(1, -2.5, 0.5);
    scene.add(buttonDown);

    // Load font and add text to buttons
    fontLoader.load('https://threejs.org/examples/fonts/helvetiker_regular.typeface.json', function(font) {
        const textMaterial = new THREE.MeshBasicMaterial({ color: 0xffffff });

        const upTextGeometry = new THREE.TextGeometry('Up', {
            font: font,
            size: 0.2,
            height: 0.05,
        });
        buttonUpText = new THREE.Mesh(upTextGeometry, textMaterial);
        buttonUpText.position.set(-1.3, -2.5, 0.6);
        scene.add(buttonUpText);

        const downTextGeometry = new THREE.TextGeometry('Down', {
            font: font,
            size: 0.2,
            height: 0.05,
        });
        buttonDownText = new THREE.Mesh(downTextGeometry, textMaterial);
        buttonDownText.position.set(0.7, -2.5, 0.6);
        scene.add(buttonDownText);
    });

    // Event listeners
    document.addEventListener('keydown', onDocumentKeyDown, false);
    document.addEventListener('keyup', onDocumentKeyUp, false);
    window.addEventListener('resize', onWindowResize, false);
    document.addEventListener('mousedown', onMouseDown, false);
    document.addEventListener('touchstart', onTouchStart, false);
}

function onDocumentKeyDown(event) {
    switch (event.key) {
        case 'w':
            playerSpeed = 0.1;
            break;
        case 's':
            playerSpeed = -0.1;
            break;
    }
}

function onDocumentKeyUp(event) {
    switch (event.key) {
        case 'w':
        case 's':
            playerSpeed = 0;
            break;
    }
}

function onWindowResize() {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
}

function onMouseDown(event) {
    event.preventDefault();
    mouse.x = (event.clientX / window.innerWidth) * 2 - 1;
    mouse.y = - (event.clientY / window.innerHeight) * 2 + 1;

    raycaster.setFromCamera(mouse, camera);
    const intersects = raycaster.intersectObjects([buttonUp, buttonDown]);

    if (intersects.length > 0) {
        handleButtonClick(intersects[0].object);
    }
}

function onTouchStart(event) {
    event.preventDefault();
    mouse.x = (event.touches[0].clientX / window.innerWidth) * 2 - 1;
    mouse.y = - (event.touches[0].clientY / window.innerHeight) * 2 + 1;

    raycaster.setFromCamera(mouse, camera);
    const intersects = raycaster.intersectObjects([buttonUp, buttonDown]);

    if (intersects.length > 0) {
        handleButtonClick(intersects[0].object);
    }
}

function handleButtonClick(button) {
    if (button === buttonUp) {
        playerSpeed = 0.1;
        if (gsapScriptLoaded) {
            gsap.to(buttonUp.scale, { duration: 0.2, x: 1.2, y: 1.2, z: 1.2 });
            gsap.to(buttonUp.scale, { duration: 0.2, x: 1, y: 1, z: 1, delay: 0.2 });
        }
    } else if (button === buttonDown) {
        playerSpeed = -0.1;
        if (gsapScriptLoaded) {
            gsap.to(buttonDown.scale, { duration: 0.2, x: 1.2, y: 1.2, z: 1.2 });
            gsap.to(buttonDown.scale, { duration: 0.2, x: 1, y: 1, z: 1, delay: 0.2 });
        }
    }
}

function updateScore() {
    scoreElement.textContent = `${playerScore} - ${computerScore}`;
}

function animate() {
    requestAnimationFrame(animate);

    // Move player paddle
    playerPaddle.position.y += playerSpeed;
    if (playerPaddle.position.y > 2.1) playerPaddle.position.y = 2.1;
    if (playerPaddle.position.y < -2.1) playerPaddle.position.y = -2.1;

    // Computer paddle follows the ball
    computerPaddle.position.y = THREE.MathUtils.lerp(computerPaddle.position.y, ball.position.y, 0.05);
    if (computerPaddle.position.y > 2.1) computerPaddle.position.y = 2.1;
    if (computerPaddle.position.y < -2.1) computerPaddle.position.y = -2.1;

    // Move ball
    ball.position.add(ballSpeed);
    ball.rotation.x += 0.1;
    ball.rotation.y += 0.1;

    // Ball collision with top and bottom borders
    if (ball.position.y > 2.4 || ball.position.y < -2.4) ballSpeed.y = -ballSpeed.y;

    // Ball collision with paddles
    if (ball.position.x < -3.4 && Math.abs(ball.position.y - playerPaddle.position.y) < 0.5) {
        ballSpeed.x = -ballSpeed.x;
    }
    if (ball.position.x > 3.4 && Math.abs(ball.position.y - computerPaddle.position.y) < 0.5) {
        ballSpeed.x = -ballSpeed.x;
    }

    // Score update and ball reset on scoring
    if (ball.position.x > 4) {
        playerScore++;
        updateScore();
        ball.position.set(0, 0, 0);
        ballSpeed.set(0.05, 0.05, 0);
    } else if (ball.position.x < -4) {
        computerScore++;
        updateScore();
        ball.position.set(0, 0, 0);
        ballSpeed.set(0.05, 0.05, 0);
    }

    renderer.render(scene, camera);
}
