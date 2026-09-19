const sharp = require('sharp');
const path = require('path');
const fs = require('fs');

const SRC = path.join(__dirname, 'Assets', 'egrator-logo.png');
const BRAND = path.join(__dirname, 'engine', 'browser', 'branding', 'egator');
const SRC_BRAND = path.join(__dirname, 'src', 'browser', 'branding', 'egator');

async function keyBlackToAlpha(inputBuffer) {
  const { data, info } = await sharp(inputBuffer)
    .ensureAlpha()
    .raw()
    .toBuffer({ resolveWithObject: true });
  const out = Buffer.from(data);
  for (let i = 0; i < out.length; i += info.channels) {
    const r = out[i], g = out[i + 1], b = out[i + 2];
    const lum = 0.299 * r + 0.587 * g + 0.114 * b;
    if (lum < 40) {
      out[i + 3] = 0; // czarne tlo + dziura -> przezroczyste
    }
  }
  return sharp(out, { raw: { width: info.width, height: info.height, channels: 4 } }).png().toBuffer();
}

(async () => {
  const keyed = await keyBlackToAlpha(fs.readFileSync(SRC));
  fs.writeFileSync(path.join(__dirname, 'Assets', 'egrator-logo-alpha.png'), keyed);

  const sizes = [16, 22, 24, 32, 48, 64, 128, 256];
  for (const s of sizes) {
    await sharp(keyed).resize(s, s).png().toFile(path.join(BRAND, `default${s}.png`));
    await sharp(keyed).resize(s, s).png().toFile(path.join(SRC_BRAND, `default${s}.png`));
  }
  // Windows start-menu tiles + about dialog
  const targets = [
    ['VisualElements_70.png', 70], ['VisualElements_150.png', 150],
    ['PrivateBrowsing_70.png', 70], ['PrivateBrowsing_150.png', 150],
  ];
  for (const [name, s] of targets) {
    await sharp(keyed).resize(s, s).png().toFile(path.join(BRAND, name));
    await sharp(keyed).resize(s, s).png().toFile(path.join(SRC_BRAND, name));
  }
  await sharp(keyed).resize(256, 256).png().toFile(path.join(BRAND, 'content', 'about-logo.png'));
  await sharp(keyed).resize(512, 512).png().toFile(path.join(BRAND, 'content', 'about-logo@2x.png'));
  await sharp(keyed).resize(256, 256).png().toFile(path.join(BRAND, 'content', 'about-logo-private.png'));
  await sharp(keyed).resize(512, 512).png().toFile(path.join(BRAND, 'content', 'about-logo-private@2x.png'));
  await sharp(keyed).resize(128, 128).png().toFile(path.join(BRAND, 'content', 'about.png'));
  console.log('PNG-y wygenerowane');
})();
