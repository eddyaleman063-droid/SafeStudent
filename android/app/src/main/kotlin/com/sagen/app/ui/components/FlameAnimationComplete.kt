package com.sagen.app.ui.components

import androidx.compose.animation.core.*
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.*
import androidx.compose.ui.graphics.drawscope.DrawScope
import androidx.compose.ui.graphics.drawscope.drawIntoCanvas
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlin.math.abs
import kotlin.math.sin

/**
 * SAGEN PREMIUM FLAME ANIMATION — V2
 * 10 enhancements over the base spec:
 *   1.  Drop shadow / glow exterior
 *   2.  Energy ball fade-in at CHARGE start
 *   3.  13 particles (7 spec + 6 extra small)
 *   4.  Color lerp per particle (warm → cool)
 *   5.  Anticipatory squish before CHARGE
 *   6.  Edge-born particles
 *   7.  Expansion ring + counter-spark on EXPLODE
 *   8.  Crossfade IDLE → CHARGE
 *   9.  Inner droplet pulse on ignition
 *  10. Random drift variation per cycle
 *
 * FROZEN / DEFROSTING — non-destructive addition:
 *   FROZEN:   ice-shaded flame with gentle infinite pulse
 *   DEFROSTING: ice-shatter tremble, then spring-transition to FLOAT
 */
@Composable
fun FlameAnimationComplete(
    modifier: Modifier = Modifier,
    phase: FlamePhase? = null,
    autoPlay: Boolean = true,
    onPhaseChange: ((FlamePhase) -> Unit)? = null,
    onAnimationComplete: (() -> Unit)? = null
) {
    var triggerAnimation by remember { mutableStateOf(0) }
    var currentPhase by remember { mutableStateOf(FlamePhase.IDLE) }

    val chargeProgress = remember { Animatable(0f) }
    val sparkProgress = remember { Animatable(0f) }
    val crossfadeProgress = remember { Animatable(0f) }
    val anticipateProgress = remember { Animatable(0f) }
    val dropletPulse = remember { Animatable(0f) }
    val ringProgress = remember { Animatable(0f) }
    val defrostProgress = remember { Animatable(0f) }

    val idleRotationTransition = rememberInfiniteTransition(label = "idle_rotation")
    val idleRotationProgress by idleRotationTransition.animateFloat(
        initialValue = 0f, targetValue = 1f,
        animationSpec = infiniteRepeatable(
            animation = tween(4200, easing = CubicBezierEasing(0.45f, 0.05f, 0.55f, 0.95f)),
            repeatMode = RepeatMode.Restart
        ),
        label = "idle_rotation"
    )

    val idleScaleXTransition = rememberInfiniteTransition(label = "idle_scaleX")
    val idleScaleXProgress by idleScaleXTransition.animateFloat(
        initialValue = 0f, targetValue = 1f,
        animationSpec = infiniteRepeatable(
            animation = tween(3600, easing = FastOutSlowInEasing),
            repeatMode = RepeatMode.Restart
        ),
        label = "idle_scaleX"
    )

    val floatRotationTransition = rememberInfiniteTransition(label = "float_rotation")
    val floatRotationProgress by floatRotationTransition.animateFloat(
        initialValue = 0f, targetValue = 1f,
        animationSpec = infiniteRepeatable(
            animation = tween(2400, easing = FastOutSlowInEasing),
            repeatMode = RepeatMode.Restart
        ),
        label = "float_rotation"
    )

    val floatScaleYTransition = rememberInfiniteTransition(label = "float_scaleY")
    val floatScaleYProgress by floatScaleYTransition.animateFloat(
        initialValue = 0f, targetValue = 1f,
        animationSpec = infiniteRepeatable(
            animation = tween(2400, easing = FastOutSlowInEasing),
            repeatMode = RepeatMode.Restart
        ),
        label = "float_scaleY"
    )

    val innerDropletTransition = rememberInfiniteTransition(label = "inner_droplet")
    val innerDropletProgress by innerDropletTransition.animateFloat(
        initialValue = 0f, targetValue = 1f,
        animationSpec = infiniteRepeatable(
            animation = tween(2400, easing = FastOutSlowInEasing, delayMillis = 120),
            repeatMode = RepeatMode.Restart
        ),
        label = "inner_droplet"
    )

    val frozenPulseTransition = rememberInfiniteTransition(label = "frozen_pulse")
    val frozenPulseProgress by frozenPulseTransition.animateFloat(
        initialValue = 0.97f, targetValue = 1.03f,
        animationSpec = infiniteRepeatable(
            animation = tween(2000, easing = LinearEasing),
            repeatMode = RepeatMode.Reverse
        ),
        label = "frozen_pulse"
    )

    val particleConfigs = remember {
        listOf(
            // Core 7 spec particles
            ParticleConfig(116f, 26f, 9f, 44f, -12f, 1050, 0, 550, Color(0xFFFFD600), Color(0xFFFF3D00), false),
            ParticleConfig(91f, 52f, 7f, 34f, 8f, 900, 300, 700, Color(0xFFFFA000), Color(0xFFE65100), false),
            ParticleConfig(70f, 56f, 6f, 28f, -15f, 1100, 580, 600, Color(0xFFFFD600), Color(0xFFFF6D00), false),
            ParticleConfig(136f, 54f, 7f, 32f, 14f, 950, 850, 750, Color(0xFFFFB300), Color(0xFFBF360C), false),
            ParticleConfig(106f, 36f, 8f, 38f, 6f, 1200, 1100, 450, Color(0xFFFFE082), Color(0xFFFF8F00), false),
            ParticleConfig(80f, 40f, 5f, 24f, -10f, 850, 1400, 900, Color(0xFFFFD600), Color(0xFFDD2C00), false),
            ParticleConfig(128f, 38f, 6f, 30f, 11f, 1000, 1700, 650, Color(0xFFFFCA28), Color(0xFFFF6F00), false),
            // Extra small particles (denser ember field)
            ParticleConfig(100f, 30f, 4f, 50f, -8f, 700, 100, 400, Color(0xFFFFD600), Color(0xFFFF3D00), false),
            ParticleConfig(85f, 45f, 3f, 38f, 12f, 650, 450, 500, Color(0xFFFFA000), Color(0xFFE65100), false),
            ParticleConfig(115f, 35f, 4f, 42f, -18f, 750, 700, 350, Color(0xFFFFE082), Color(0xFFFF8F00), false),
            // Edge-born particles (spawn from flame perimeter)
            ParticleConfig(160f, 100f, 5f, 30f, 20f, 800, 200, 600, Color(0xFFFFB300), Color(0xFFBF360C), true),
            ParticleConfig(40f, 120f, 4f, 35f, -22f, 850, 600, 550, Color(0xFFFFD600), Color(0xFFDD2C00), true),
            ParticleConfig(170f, 150f, 3f, 25f, 15f, 600, 1000, 700, Color(0xFFFFCA28), Color(0xFFFF6F00), true),
        )
    }

    val particleStates = particleConfigs.map { config ->
        remember { ParticleAnimationState(config) }
    }

    val iceParticleStates = iceParticleConfigs.map { remember { IceParticleAnimationState() } }

    // ── Phase orchestration ──

    LaunchedEffect(triggerAnimation, phase) {
        // External FROZEN override
        if (phase == FlamePhase.FROZEN) {
            currentPhase = FlamePhase.FROZEN
            onPhaseChange?.invoke(FlamePhase.FROZEN)
            return@LaunchedEffect
        }

        // External DEFROSTING override: ice shatter → spring to FLOAT
        if (phase == FlamePhase.DEFROSTING) {
            currentPhase = FlamePhase.DEFROSTING
            onPhaseChange?.invoke(FlamePhase.DEFROSTING)
            defrostProgress.snapTo(0f)
            iceParticleStates.forEach { launch { it.animate() } }
            defrostProgress.animateTo(
                targetValue = 1f,
                animationSpec = spring(stiffness = 160f, dampingRatio = 0.65f)
            )
            currentPhase = FlamePhase.FLOAT
            onPhaseChange?.invoke(FlamePhase.FLOAT)
            particleStates.forEach { state ->
                launch {
                    while (currentPhase == FlamePhase.FLOAT) {
                        state.animate()
                        state.nextCycle()
                        delay(state.config.gap.toLong())
                    }
                }
            }
            onAnimationComplete?.invoke()
            return@LaunchedEffect
        }

        if (triggerAnimation > 0 || autoPlay) {
            // Reset
            currentPhase = FlamePhase.IDLE
            onPhaseChange?.invoke(FlamePhase.IDLE)
            chargeProgress.snapTo(0f)
            sparkProgress.snapTo(0f)
            crossfadeProgress.snapTo(0f)
            anticipateProgress.snapTo(0f)
            dropletPulse.snapTo(0f)
            ringProgress.snapTo(0f)
            particleStates.forEach { it.reset() }

            // ── IDLE (250ms normal + 100ms anticipatory squish) ──
            delay(250)

            launch { anticipateProgress.animateTo(1f, tween(100, easing = FastOutSlowInEasing)) }
            delay(100)

            // ── CHARGE (610ms) ──
            currentPhase = FlamePhase.CHARGE
            onPhaseChange?.invoke(FlamePhase.CHARGE)

            launch { crossfadeProgress.animateTo(1f, tween(60, easing = LinearEasing)) }

            launch {
                chargeProgress.animateTo(
                    targetValue = 1f,
                    animationSpec = tween(
                        durationMillis = 1800,
                        easing = CubicBezierEasing(0.85f, 0f, 0.15f, 1f)
                    )
                )
            }
            delay(610)

            // ── EXPLODE (240ms) ──
            currentPhase = FlamePhase.EXPLODE
            onPhaseChange?.invoke(FlamePhase.EXPLODE)

            launch { dropletPulse.animateTo(1f, tween(120, easing = FastOutSlowInEasing)) }
            launch { ringProgress.animateTo(1f, tween(300, easing = CubicBezierEasing(0f, 0f, 0.2f, 1f))) }

            launch {
                sparkProgress.animateTo(
                    targetValue = 1f,
                    animationSpec = keyframes {
                        durationMillis = 750
                        0f at 0
                        0.45f at 337 with CubicBezierEasing(0.85f, 0f, 0.15f, 1f)
                        1f at 750
                    }
                )
            }
            delay(240)

            // ── FLOAT (infinite) ──
            currentPhase = FlamePhase.FLOAT
            onPhaseChange?.invoke(FlamePhase.FLOAT)

            particleStates.forEach { state ->
                launch {
                    delay(state.config.delay.toLong())
                    while (currentPhase == FlamePhase.FLOAT) {
                        state.animate()
                        state.nextCycle()
                        delay(state.config.gap.toLong())
                    }
                }
            }

            onAnimationComplete?.invoke()
        }
    }

    Box(
        modifier = modifier.clickable { triggerAnimation++ }
    ) {
        Canvas(modifier = Modifier.fillMaxSize()) {
            val scale = size.width / 200f

            drawIntoCanvas { canvas ->
                canvas.save()
                canvas.scale(scale, scale)

                when (currentPhase) {
                    FlamePhase.IDLE -> {
                        drawIdlePhase(canvas, idleRotationProgress, idleScaleXProgress, anticipateProgress.value)
                    }
                    FlamePhase.CHARGE -> {
                        val xfade = crossfadeProgress.value
                        if (xfade < 1f) {
                            drawIdlePhase(canvas, idleRotationProgress, idleScaleXProgress, 0f, alpha = 1f - xfade)
                        }
                        drawChargePhase(canvas, chargeProgress.value, xfade)
                    }
                    FlamePhase.EXPLODE -> {
                        drawExplodePhase(canvas, sparkProgress.value, dropletPulse.value, ringProgress.value)
                    }
                    FlamePhase.FLOAT -> {
                        drawFloatPhase(
                            canvas, floatRotationProgress, floatScaleYProgress,
                            innerDropletProgress, particleStates
                        )
                    }
                    FlamePhase.FROZEN -> {
                        drawFrozenPhase(canvas, frozenPulseProgress)
                    }
                    FlamePhase.DEFROSTING -> {
                        drawDefrostPhase(canvas, defrostProgress.value, iceParticleStates)
                    }
                }

                canvas.restore()
            }
        }
    }
}

enum class FlamePhase { IDLE, CHARGE, EXPLODE, FLOAT, FROZEN, DEFROSTING }

// ── Particle system ──

private data class ParticleConfig(
    val x: Float, val y: Float, val size: Float,
    val rise: Float, val drift: Float,
    val duration: Int, val delay: Int, val gap: Int,
    val colorStart: Color, val colorEnd: Color,
    val isEdge: Boolean
)

private class ParticleAnimationState(val config: ParticleConfig) {
    private val _progress = Animatable(0f)
    val progress: Float get() = _progress.value
    private var scaleVariation = 0f
    private var driftMultiplier = 1f

    suspend fun animate() {
        scaleVariation = (Math.random() * 0.2).toFloat()
        _progress.snapTo(0f)
        _progress.animateTo(
            targetValue = 1f,
            animationSpec = tween(
                durationMillis = config.duration,
                easing = CubicBezierEasing(0.25f, 0.46f, 0.45f, 0.94f)
            )
        )
    }

    fun nextCycle() {
        driftMultiplier = 0.8f + (Math.random() * 0.4f).toFloat()
    }

    fun reset() {
        _progress.updateBounds(0f, 0f)
    }

    fun getX(): Float {
        val baseDrift = config.drift * driftMultiplier
        return interpolate(progress, 0f, baseDrift * 0.3f, baseDrift * 0.7f, baseDrift)
    }

    fun getY(): Float = interpolate(progress, 0f, -config.rise * 0.25f, -config.rise * 0.65f, -config.rise)
    fun getOpacity(): Float = interpolate(progress, 0f, 1f, 0.85f, 0f)
    fun getScale(): Float = interpolate(progress, 0.4f, 1.15f + scaleVariation, 0.75f, 0.25f)
    fun getColor(): Color = lerpColor(config.colorStart, config.colorEnd, progress)

    private fun interpolate(t: Float, v0: Float, v1: Float, v2: Float, v3: Float): Float {
        val segment = (t * 3f).coerceIn(0f, 3f)
        val idx = segment.toInt().coerceIn(0, 2)
        val frac = segment - idx
        val values = arrayOf(v0, v1, v2, v3)
        return values[idx] + (values[idx + 1] - values[idx]) * frac
    }

    private fun lerpColor(a: Color, b: Color, t: Float): Color {
        return Color(
            a.red + (b.red - a.red) * t,
            a.green + (b.green - a.green) * t,
            a.blue + (b.blue - a.blue) * t,
            a.alpha + (b.alpha - a.alpha) * t
        )
    }
}

// ── Ice particle system (for DEFROSTING shatter) ──

private data class IceParticleConfig(
    val x: Float, val y: Float, val size: Float,
    val rise: Float, val drift: Float,
    val duration: Int,
    val color: Color
)

private class IceParticleAnimationState {
    private val _progress = Animatable(0f)
    val progress: Float get() = _progress.value

    suspend fun animate() {
        _progress.snapTo(0f)
        _progress.animateTo(
            targetValue = 1f,
            animationSpec = tween(durationMillis = 480, easing = LinearOutSlowInEasing)
        )
    }

    fun getX(config: IceParticleConfig, t: Float): Float = config.drift * t
    fun getY(config: IceParticleConfig, t: Float): Float = config.rise * t
    fun getOpacity(t: Float): Float = (1f - t).coerceIn(0f, 1f)
    fun getScale(t: Float): Float = (1f - t * 0.4f).coerceIn(0f, 1f)
}

// Top-level ice particle configs shared between composable and drawDefrostPhase
private val iceParticleConfigs = listOf(
    IceParticleConfig(100f, 150f, 8f, 75f, -55f, 480, Color(0xFFE0F7FA)),
    IceParticleConfig(120f, 160f, 10f, 90f, 45f, 420, Color(0xFFB2EBF2)),
    IceParticleConfig(80f, 140f, 7f, 70f, -30f, 460, Color(0xFF80DEEA)),
    IceParticleConfig(130f, 130f, 9f, 85f, 60f, 400, Color(0xFFFFFFFF))
)

// ── Drawing functions ──

private fun drawFlameShadow(canvas: Canvas, isLit: Boolean, scaleY: Float = 1f) {
    if (isLit) {
        val glowPaint = Paint().apply {
            color = Color(0xFFF7941D).copy(alpha = 0.70f)
            style = PaintingStyle.Fill
        }
        canvas.save()
        canvas.translate(100f, 235f)
        canvas.scale(1f, scaleY)
        canvas.drawCircle(Offset(0f, 0f), 35f, glowPaint)
        canvas.restore()

        val secondary = Paint().apply {
            color = Color(0xFFB45A00).copy(alpha = 0.45f)
            style = PaintingStyle.Fill
        }
        canvas.save()
        canvas.translate(100f, 243f)
        canvas.drawCircle(Offset(0f, 0f), 28f, secondary)
        canvas.restore()
    } else {
        val shadowPaint = Paint().apply {
            color = Color.Black.copy(alpha = 0.50f)
            style = PaintingStyle.Fill
        }
        canvas.save()
        canvas.translate(100f, 235f)
        canvas.scale(1f, scaleY)
        canvas.drawCircle(Offset(0f, 0f), 35f, shadowPaint)
        canvas.restore()
    }
}

private fun DrawScope.drawIdlePhase(
    canvas: Canvas,
    rotationProgress: Float,
    scaleXProgress: Float,
    anticipateProgress: Float,
    alpha: Float = 1f
) {
    val rotation = interpolateKeyframes(rotationProgress, 0f, -3f, 4f, -2.5f, 3.5f, -3f, 0f)
    val scaleX = interpolateKeyframes(scaleXProgress, 1f, 1.015f, 0.99f, 1.01f, 1f)
    val squish = 1f - anticipateProgress * 0.05f

    drawFlameShadow(canvas, isLit = false)

    canvas.save()
    canvas.translate(100f, 220f)
    canvas.rotate(rotation)
    canvas.scale(1f, squish)
    canvas.translate(-100f, -220f)

    canvas.save()
    canvas.translate(100f, 140f)
    canvas.scale(scaleX, 1f)
    canvas.translate(-100f, -140f)
    canvas.drawPath(FlameGeometry.outerPath, Paint().apply {
        color = Color(0xFFD4D4D4).copy(alpha = alpha)
        style = PaintingStyle.Fill
    })
    canvas.restore()

    canvas.drawPath(FlameGeometry.innerPath, Paint().apply {
        color = Color.White.copy(alpha = alpha)
        style = PaintingStyle.Fill
    })
    canvas.restore()
}

private fun DrawScope.drawChargePhase(canvas: Canvas, progress: Float, crossfade: Float) {
    drawFlameShadow(canvas, isLit = false)

    val greyAlpha = 1f - crossfade
    canvas.drawPath(FlameGeometry.outerPath, Paint().apply {
        color = Color(0xFFD4D4D4).copy(alpha = greyAlpha)
        style = PaintingStyle.Fill
    })
    canvas.drawPath(FlameGeometry.innerPath, Paint().apply {
        color = Color.White.copy(alpha = greyAlpha)
        style = PaintingStyle.Fill
    })

    val ballY = getChargeKeyframe(progress, 0f, -45f, 0f, -55f, 0f, -65f, 0f, -70f, 0f)
    val scaleY = getChargeKeyframe(progress, 1f, 0.75f, 1.25f, 0.7f, 1.3f, 0.65f, 1.35f, 0.6f, 1.4f)
    val scaleX = getChargeKeyframe(progress, 1f, 1.25f, 0.85f, 1.3f, 0.8f, 1.35f, 0.75f, 1.4f, 0.7f)

    canvas.save()
    canvas.clipPath(FlameGeometry.outerPath)
    canvas.translate(100f, 148f + ballY)
    canvas.scale(scaleX, scaleY)

    val ballAlpha = (progress / 0.05f).coerceIn(0f, 1f)
    val ballScale = (progress / 0.05f).coerceIn(0f, 1f)
    canvas.save()
    canvas.scale(ballScale, ballScale)
    val energyPaint = shaderPaint(FlameGradients.energyBallBrush, alpha = ballAlpha)
    canvas.drawCircle(Offset(0f, 0f), 17f, energyPaint)
    canvas.restore()
    canvas.restore()

    val shellScale = getShellKeyframe(progress, 1f, 1f, 1.04f, 1f, 1f, 1.05f, 1f, 1f, 1.06f, 1f)
    val shellOpacity = getShellKeyframe(progress, 0f, 0.3f, 0.7f, 0f, 0.35f, 0.75f, 0f, 0.4f, 0.8f, 0f)

    if (shellOpacity > 0.01f) {
        canvas.save()
        canvas.translate(100f, 220f)
        canvas.scale(1f, shellScale)
        canvas.translate(-100f, -220f)
        canvas.drawPath(FlameGeometry.outerPath, Paint().apply {
            color = Color(0xFFFFD600).copy(alpha = shellOpacity * 0.2f)
            style = PaintingStyle.Stroke
            strokeWidth = 3f
        })
        canvas.restore()
    }
}

private fun DrawScope.drawExplodePhase(
    canvas: Canvas,
    sparkProgress: Float,
    dropletPulse: Float,
    ringProgress: Float
) {
    drawFlameShadow(canvas, isLit = true)

    val pulseScale = 1f + dropletPulse * 0.12f
    val pulseAlpha = 1f - dropletPulse * 0.15f

    canvas.drawPath(FlameGeometry.outerPath, shaderPaint(FlameGradients.outerFlameBrush))

    canvas.save()
    canvas.translate(100f, 140f)
    canvas.scale(pulseScale, pulseScale)
    canvas.translate(-100f, -140f)
    canvas.drawPath(FlameGeometry.innerPath, shaderPaint(FlameGradients.innerDropletBrush, alpha = pulseAlpha))
    canvas.restore()

    // Expansion ring
    val ringRadius = ringProgress * 60f
    val ringOpacity = (1f - ringProgress) * 0.5f
    if (ringOpacity > 0.01f) {
        canvas.drawCircle(Offset(100f, 140f), ringRadius, Paint().apply {
            color = Color(0xFFFFD600).copy(alpha = ringOpacity)
            style = PaintingStyle.Stroke
            strokeWidth = 2f
        })
    }

    // Counter-spark (small, opposite direction)
    val cY = getSparkKeyframe(sparkProgress, -2f, 35f, 25f)
    val cOpacity = getSparkKeyframe(sparkProgress, 1f, 0.5f, 0f)
    val cScale = getSparkKeyframe(sparkProgress, 1f, 0.25f, 0.1f)
    if (cOpacity > 0.01f) {
        canvas.save()
        canvas.translate(82f, 220f + cY)
        canvas.scale(cScale, cScale)
        canvas.translate(-82f, -220f)
        canvas.drawPath(FlameGeometry.sparkPath, Paint().apply {
            color = Color(0xFFFFB300).copy(alpha = cOpacity)
            style = PaintingStyle.Fill
        })
        canvas.restore()
    }

    // Main explosion spark
    val y = getSparkKeyframe(sparkProgress, -2f, -68f, -56f)
    val opacity = getSparkKeyframe(sparkProgress, 1f, 0.85f, 0f)
    val scale = getSparkKeyframe(sparkProgress, 1f, 0.35f, 0.2f)
    val scaleY = getSparkKeyframe(sparkProgress, 1f, 1.4f, 0.6f)

    if (opacity > 0.01f) {
        canvas.save()
        canvas.translate(0f, y)
        canvas.translate(118f, 20f)
        canvas.scale(scale, scale * scaleY)
        canvas.translate(-118f, -20f)
        canvas.drawPath(FlameGeometry.sparkPath, Paint().apply {
            color = Color(0xFFFFD600).copy(alpha = opacity)
            style = PaintingStyle.Fill
        })
        canvas.restore()
    }
}

private fun DrawScope.drawFloatPhase(
    canvas: Canvas,
    rotationProgress: Float,
    scaleYProgress: Float,
    innerDropletProgress: Float,
    particleStates: List<ParticleAnimationState>
) {
    drawFlameShadow(canvas, isLit = true)

    val rotation = interpolateKeyframes(rotationProgress, 0f, 1.5f, -1f, 1f, 0f)
    val scaleY = interpolateKeyframes(scaleYProgress, 1f, 1.03f, 0.98f, 1.02f, 1f)

    canvas.save()
    canvas.translate(100f, 220f)
    canvas.rotate(rotation)
    canvas.scale(1f, scaleY)
    canvas.translate(-100f, -220f)
    canvas.drawPath(FlameGeometry.outerPath, shaderPaint(FlameGradients.outerFlameBrush))
    canvas.restore()

    val innerY = interpolateKeyframes(innerDropletProgress, 0f, 1.2f, -0.8f, 0f)
    val innerScaleY = interpolateKeyframes(innerDropletProgress, 1f, 1.02f, 0.99f, 1f)

    canvas.save()
    canvas.translate(0f, innerY)
    canvas.translate(100f, 140f)
    canvas.scale(1f, innerScaleY)
    canvas.translate(-100f, -140f)
    canvas.drawPath(FlameGeometry.innerPath, shaderPaint(FlameGradients.innerDropletBrush))
    canvas.restore()

    val particlePaint = Paint().apply {
        style = PaintingStyle.Fill
    }

    particleStates.forEach { state ->
        val opacity = state.getOpacity()
        if (opacity > 0.01f) {
            val offsetX = state.getX()
            val offsetY = state.getY()
            val scale = state.getScale()
            val baseX = state.config.x + offsetX
            val baseY = state.config.y + offsetY
            val pSize = state.config.size * scale

            val path = createParticlePath(baseX, baseY, pSize)
            particlePaint.color = state.getColor().copy(alpha = opacity)
            canvas.drawPath(path, particlePaint)
        }
    }
}

// ── FROZEN phase ──

private fun DrawScope.drawFrozenPhase(canvas: Canvas, pulseFactor: Float) {
    canvas.save()
    canvas.translate(100f, 220f)
    canvas.scale(pulseFactor, pulseFactor)
    canvas.translate(-100f, -220f)

    canvas.drawPath(FlameGeometry.outerPath, shaderPaint(IceGradients.frozenOuterBrush))
    canvas.drawPath(FlameGeometry.innerPath, shaderPaint(IceGradients.frozenInnerBrush))
    canvas.drawPath(FlameGeometry.outerPath, IceGradients.frozenGlassStrokePaint)

    canvas.restore()
}

// ── DEFROSTING phase: ice shatter tremble → spring to fire ──

private fun DrawScope.drawDefrostPhase(
    canvas: Canvas,
    progress: Float,
    iceParticleStates: List<IceParticleAnimationState>
) {
    val tremorX = if (progress < 0.4f) sin(progress * 80f) * 2.5f else 0f

    canvas.save()
    canvas.translate(tremorX, 0f)

    if (progress < 0.4f) {
        // Ice appearance with tremble
        canvas.drawPath(FlameGeometry.outerPath, shaderPaint(IceGradients.frozenOuterBrush))
        canvas.drawPath(FlameGeometry.innerPath, shaderPaint(IceGradients.frozenInnerBrush))
        canvas.drawPath(FlameGeometry.outerPath, IceGradients.frozenGlassStrokePaint)
    } else {
        // Spring transition to fire
        val overshootY = (1f - progress) * 12f
        canvas.save()
        canvas.translate(0f, overshootY)
        canvas.drawPath(FlameGeometry.outerPath, shaderPaint(FlameGradients.outerFlameBrush))
        canvas.drawPath(FlameGeometry.innerPath, shaderPaint(FlameGradients.innerDropletBrush))
        canvas.restore()
    }
    canvas.restore()

    // Ice shards shattering downward
    val shardPaint = Paint().apply { style = PaintingStyle.Fill }
    iceParticleStates.forEach { state ->
        val config = iceParticleConfigs[iceParticleStates.indexOf(state)]
        val t = state.progress
        val opacity = state.getOpacity(t)
        if (opacity > 0.01f) {
            val pX = config.x + state.getX(config, t)
            val pY = config.y + state.getY(config, t)
            val rad = config.size * state.getScale(t)

            val shardPath = shardTrianglePath(pX, pY, rad)
            shardPaint.color = config.color.copy(alpha = opacity)
            canvas.drawPath(shardPath, shardPaint)
        }
    }
}

private fun shardTrianglePath(cx: Float, cy: Float, r: Float): Path = Path().apply {
    moveTo(cx, cy - r)
    lineTo(cx + r, cy + r / 2f)
    lineTo(cx - r / 2f, cy + r)
    close()
}

// ── Geometry & gradients ──

private object FlameGeometry {
    val outerPath = parseSvgPath(
        "M 100 235 C 148 235 178 205 178 162 C 178 120 162 88 148 68 " +
        "C 140 50 126 26 116 22 C 106 18 94 42 90 66 C 86 50 72 36 64 48 " +
        "C 52 62 22 108 22 162 C 22 205 52 235 100 235 Z"
    )
    val innerPath = parseSvgPath(
        "M 100 192 C 80 192 64 174 64 154 C 64 134 80 112 100 102 " +
        "C 120 112 136 134 136 154 C 136 174 120 192 100 192 Z"
    )
    val sparkPath = parseSvgPath(
        "M 118 36 C 114 29 109 22 109 15 C 109 8 113 4 118 4 " +
        "C 123 4 127 8 127 15 C 127 22 122 29 118 36 Z"
    )
}

private object IceGradients {
    val frozenOuterBrush = Brush.verticalGradient(
        0f to Color(0xFF0D47A1),
        0.55f to Color(0xFF00B0FF),
        1f to Color(0xFF00E5FF)
    )

    val frozenInnerBrush = Brush.radialGradient(
        0f to Color(0xFFFFFFFF),
        0.35f to Color(0xFFB2EBF2),
        1f to Color(0xFF0091EA),
        center = Offset(100f, 140f),
        radius = 52f
    )

    val frozenGlassStrokePaint = Paint().apply {
        color = Color(0xFFFFFFFF).copy(alpha = 0.5f)
        style = PaintingStyle.Stroke
        strokeWidth = 3.5f
    }
}

private object FlameGradients {
    val outerFlameBrush = Brush.verticalGradient(
        0f to Color(0xFFB85E00),
        0.38f to Color(0xFFF7941D),
        1f to Color(0xFFFFB800)
    )
    val innerDropletBrush = Brush.radialGradient(
        0f to Color(0xFFFFEE58),
        0.48f to Color(0xFFFFD600),
        1f to Color(0xFFFF9800),
        center = Offset(100f, 140f),
        radius = 56f
    )
    val energyBallBrush = Brush.radialGradient(
        0f to Color.White,
        0.35f to Color(0xFFFFFDE7),
        1f to Color(0xFFFFD600),
        center = Offset(0f, 0f),
        radius = 17f
    )
}

// ── Helpers ──

private fun createParticlePath(x: Float, y: Float, s: Float): Path {
    val s07 = s * 0.7f
    val s03 = s * 0.3f
    return Path().apply {
        moveTo(x, y + s)
        cubicTo(x - s07, y + s03, x - s07, y - s03, x, y - s)
        cubicTo(x + s07, y - s03, x + s07, y + s03, x, y + s)
        close()
    }
}

private fun parseSvgPath(data: String): Path {
    val path = Path()
    val tokens = data.trim().split(Regex("(?=[MCLZ])"))
    for (token in tokens) {
        if (token.isBlank()) continue
        val cmd = token[0]
        val nums = token.substring(1).trim().split(Regex("\\s+")).mapNotNull { it.toFloatOrNull() }
        when (cmd) {
            'M' -> if (nums.size >= 2) path.moveTo(nums[0], nums[1])
            'L' -> if (nums.size >= 2) path.lineTo(nums[0], nums[1])
            'C' -> {
                var i = 0
                while (i + 5 < nums.size) {
                    path.cubicTo(nums[i], nums[i + 1], nums[i + 2], nums[i + 3], nums[i + 4], nums[i + 5])
                    i += 6
                }
            }
            'Z' -> path.close()
        }
    }
    return path
}

// ── Brush-to-Paint helper ──

private fun DrawScope.shaderPaint(
    brush: Brush,
    alpha: Float = 1f,
    style: PaintingStyle = PaintingStyle.Fill
): Paint = Paint().apply {
    brush.applyTo(size, this, alpha)
    this.style = style
}

// ── Keyframe interpolation ──

private fun interpolateKeyframes(t: Float, vararg values: Float): Float {
    val n = values.size - 1
    val segment = (t * n).coerceIn(0f, n.toFloat())
    val idx = segment.toInt().coerceIn(0, n - 1)
    val frac = segment - idx
    return values[idx] + (values[idx + 1] - values[idx]) * frac
}

private fun getChargeKeyframe(t: Float, vararg values: Float): Float {
    val times = floatArrayOf(0f, 0.11f, 0.22f, 0.33f, 0.44f, 0.55f, 0.66f, 0.77f, 0.88f)
    return interpolateWithTimes(t, values, times)
}

private fun getShellKeyframe(t: Float, vararg values: Float): Float {
    val times = floatArrayOf(0f, 0.20f, 0.22f, 0.24f, 0.42f, 0.44f, 0.46f, 0.64f, 0.66f, 0.68f)
    return interpolateWithTimes(t, values, times)
}

private fun getSparkKeyframe(t: Float, vararg values: Float): Float {
    val times = floatArrayOf(0f, 0.45f, 1f)
    return interpolateWithTimes(t, values, times)
}

private fun interpolateWithTimes(t: Float, values: FloatArray, times: FloatArray): Float {
    if (t <= times[0]) return values[0]
    if (t >= times.last()) return values.last()
    for (i in 0 until times.size - 1) {
        if (t in times[i]..times[i + 1]) {
            val frac = (t - times[i]) / (times[i + 1] - times[i])
            return values[i] + (values[i + 1] - values[i]) * frac
        }
    }
    return values.last()
}

// ── Cubic bezier easing ──

private class CubicBezierEasing(
    private val x1: Float, private val y1: Float,
    private val x2: Float, private val y2: Float
) : Easing {
    override fun transform(fraction: Float): Float {
        if (fraction <= 0f) return 0f
        if (fraction >= 1f) return 1f
        var tMin = 0f
        var tMax = 1f
        var t = fraction
        repeat(10) {
            val x = bezierX(t)
            if (abs(x - fraction) < 0.001f) return@repeat
            if (x < fraction) tMin = t else tMax = t
            t = (tMin + tMax) / 2f
        }
        return bezierY(t)
    }

    private fun bezierX(t: Float): Float { val c = 3f * x1; val b = 3f * (x2 - x1) - c; val a = 1f - c - b; return ((a * t + b) * t + c) * t }
    private fun bezierY(t: Float): Float { val c = 3f * y1; val b = 3f * (y2 - y1) - c; val a = 1f - c - b; return ((a * t + b) * t + c) * t }
}
