
# ============================================================
# SITE-WIDE UPDATE SCRIPT
# 1. Nav bar 5% bigger (all 15 pages, normalized)
# 2. Hero 8% smaller (index, tips-calculator, paycheck-calculator)
# 3. Footer restructured (remove By State/By Industry, move FAQ to Company, add State Guide + Workforce Guide to Guides)
# 4. Footer CSS grid: 5-col → 3-col
# ============================================================

$dir  = "C:\Users\Aramm\Desktop\CCodeProjects\NoTax"
$enc  = [System.Text.Encoding]::UTF8

function Patch {
    param($path, [array]$ops)
    $c = [System.IO.File]::ReadAllText($path, $enc)
    $c = $c.Replace("`r`n", "`n")   # normalize to LF
    foreach ($op in $ops) {
        if ($c.Contains($op.old)) {
            $c = $c.Replace($op.old, $op.new)
        } else {
            Write-Warning "NOT FOUND in $([System.IO.Path]::GetFileName($path)): $($op.old.Substring(0, [Math]::Min(60,$op.old.Length)))"
        }
    }
    [System.IO.File]::WriteAllText($path, $c, $enc)
    Write-Host "  Patched: $([System.IO.Path]::GetFileName($path))"
}

# ─────────────────────────────────────────────────────────────
# SHARED: compact single-line footer HTML (13 pages share this)
# ─────────────────────────────────────────────────────────────
$oldFooter = (
    '<div class="footer-col"><h4>Guides</h4><ul><li><a href="/who-qualifies">Who Qualifies</a></li><li><a href="/how-to-find-overtime-on-w2">W-2 Guide</a></li><li><a href="/faq">FAQ</a></li></ul></div>' + "`n" +
    '      <div class="footer-col"><h4>By State</h4><ul><li><a href="/state-tax-guide">All 50 States</a></li><li><a href="/california-overtime-deduction">California</a></li><li><a href="/obbba-overtime-calculator-texas">Texas</a></li></ul></div>' + "`n" +
    '      <div class="footer-col"><h4>By Industry</h4><ul><li><a href="/nurses-overtime-tax-2025">Nurses</a></li><li><a href="/construction-workers-overtime-deduction">Construction</a></li></ul></div>' + "`n" +
    '      <div class="footer-col"><h4>Company</h4><ul><li><a href="/about">About Us</a></li><li><a href="/contact">Contact</a></li><li><a href="/privacy-policy">Privacy</a></li></ul></div>'
)
$newFooter = (
    '<div class="footer-col"><h4>Guides</h4><ul><li><a href="/who-qualifies">Who Qualifies</a></li><li><a href="/how-to-find-overtime-on-w2">W-2 Guide</a></li><li><a href="/workforce-guide">Workforce Guide</a></li><li><a href="/state-tax-guide">State Guide</a></li></ul></div>' + "`n" +
    '      <div class="footer-col"><h4>Company</h4><ul><li><a href="/about">About Us</a></li><li><a href="/contact">Contact</a></li><li><a href="/privacy-policy">Privacy</a></li><li><a href="/faq">FAQ</a></li></ul></div>'
)

# ─────────────────────────────────────────────────────────────
# GROUP A: Standard spaced CSS (12 pages)
# who-qualifies, how-to-find-overtime-on-w2, faq, state-tax-guide,
# about, contact, privacy-policy, california, nurses, construction,
# tips-calculator, paycheck-calculator
# ─────────────────────────────────────────────────────────────
$opsA = @(
    # --- NAV 5% bigger ---
    @{ old='padding: 16px 0;';                                              new='padding: 17px 0;' },
    @{ old='font-size: 22px; color: var(--white);';                         new='font-size: 23px; color: var(--white);' },
    @{ old='{ .logo { font-size: 26px; } }';                                new='{ .logo { font-size: 27px; } }' },
    @{ old='{ .logo { font-size: 28px; } }';                                new='{ .logo { font-size: 29px; } }' },
    @{ old='gap: 28px; align-items: center;';                               new='gap: 29px; align-items: center;' },
    @{ old='font-size: 14px; font-weight: 500; opacity: 0.85;';             new='font-size: 15px; font-weight: 500; opacity: 0.85;' },
    @{ old='padding: 8px 14px; border-radius: 8px; font-weight: 600; font-size: 14px;'; new='padding: 9px 15px; border-radius: 8px; font-weight: 600; font-size: 15px;' },
    # --- FOOTER CSS 5-col → 3-col ---
    @{ old='repeat(5, 1fr); } }';                                           new='repeat(3, 1fr); } }' },
    # --- FOOTER HTML ---
    @{ old=$oldFooter;                                                       new=$newFooter }
)

$groupA = @(
    'who-qualifies.html','how-to-find-overtime-on-w2.html','faq.html',
    'state-tax-guide.html','about.html','contact.html','privacy-policy.html',
    'california-overtime-deduction.html','nurses-overtime-tax-2025.html',
    'construction-workers-overtime-deduction.html',
    'tips-calculator.html','paycheck-calculator.html'
)
Write-Host "`nGroup A (standard pages):"
foreach ($f in $groupA) { Patch "$dir\$f" $opsA }

# ─────────────────────────────────────────────────────────────
# GROUP B: Texas (compressed / no-space CSS)
# ─────────────────────────────────────────────────────────────
$opsB = @(
    @{ old='padding:16px 0;';                                               new='padding:17px 0;' },
    @{ old='font-size:22px; color:var(--white);';                           new='font-size:23px; color:var(--white);' },
    @{ old='{.logo{font-size:26px;}}';                                      new='{.logo{font-size:27px;}}' },
    @{ old='{.logo{font-size:28px;}}';                                      new='{.logo{font-size:29px;}}' },
    @{ old='gap:28px; align-items:center;';                                 new='gap:29px; align-items:center;' },
    @{ old='font-size:14px; font-weight:500; opacity:.85;';                 new='font-size:15px; font-weight:500; opacity:.85;' },
    @{ old='padding: 8px 14px; border-radius: 8px; font-weight: 600; font-size: 14px;'; new='padding: 9px 15px; border-radius: 8px; font-weight: 600; font-size: 15px;' },
    @{ old='repeat(5,1fr);}}';                                              new='repeat(3,1fr);}}' },
    @{ old=$oldFooter;                                                       new=$newFooter }
)
Write-Host "`nGroup B (Texas):"
Patch "$dir\obbba-overtime-calculator-texas.html" $opsB

# ─────────────────────────────────────────────────────────────
# GROUP C: Workforce-guide (had smaller nav values for overflow prevention)
# ─────────────────────────────────────────────────────────────
$oldFooterWfg = (
    '<div class="footer-col"><h4>Guides</h4><ul><li><a href="/who-qualifies">Who Qualifies</a></li><li><a href="/workforce-guide">Workforce Guide</a></li><li><a href="/how-to-find-overtime-on-w2">W-2 Guide</a></li><li><a href="/faq">FAQ</a></li></ul></div>' + "`n" +
    '      <div class="footer-col"><h4>By State</h4><ul><li><a href="/state-tax-guide">All 50 States</a></li><li><a href="/california-overtime-deduction">California</a></li><li><a href="/obbba-overtime-calculator-texas">Texas</a></li></ul></div>' + "`n" +
    '      <div class="footer-col"><h4>By Industry</h4><ul><li><a href="/nurses-overtime-tax-2025">Nurses</a></li><li><a href="/construction-workers-overtime-deduction">Construction</a></li></ul></div>' + "`n" +
    '      <div class="footer-col"><h4>Company</h4><ul><li><a href="/about">About Us</a></li><li><a href="/contact">Contact</a></li><li><a href="/privacy-policy">Privacy</a></li></ul></div>'
)
$opsC = @(
    @{ old='padding: 16px 0;';                                              new='padding: 17px 0;' },
    @{ old='font-size: 20px; color: var(--white);';                         new='font-size: 23px; color: var(--white);' },
    @{ old='{ .logo { font-size: 23px; } }';                                new='{ .logo { font-size: 27px; } }' },
    @{ old='{ .logo { font-size: 25px; } }';                                new='{ .logo { font-size: 29px; } }' },
    @{ old='gap: 18px; align-items: center;';                               new='gap: 29px; align-items: center;' },
    @{ old='font-size: 13px; font-weight: 500; opacity: 0.85;';             new='font-size: 15px; font-weight: 500; opacity: 0.85;' },
    @{ old='padding: 8px 14px; border-radius: 8px; font-weight: 600; font-size: 13px;'; new='padding: 9px 15px; border-radius: 8px; font-weight: 600; font-size: 15px;' },
    @{ old='repeat(5, 1fr); } }';                                           new='repeat(3, 1fr); } }' },
    @{ old=$oldFooterWfg;                                                    new=$newFooter }
)
Write-Host "`nGroup C (Workforce-guide):"
Patch "$dir\workforce-guide.html" $opsC

# ─────────────────────────────────────────────────────────────
# GROUP D: index.html  (multi-line CSS + hero changes)
# ─────────────────────────────────────────────────────────────
$oldFooterIndex = (
    "      <div class=`"footer-col`">`n" +
    "        <h4>Guides</h4>`n" +
    "        <ul>`n" +
    "          <li><a href=`"/who-qualifies`">Who Qualifies</a></li>`n" +
    "          <li><a href=`"/how-to-find-overtime-on-w2`">W-2 Guide</a></li>`n" +
    "          <li><a href=`"/faq`">FAQ</a></li>`n" +
    "        </ul>`n" +
    "      </div>`n" +
    "      <div class=`"footer-col`">`n" +
    "        <h4>By State</h4>`n" +
    "        <ul>`n" +
    "          <li><a href=`"/state-tax-guide`">All 50 States</a></li>`n" +
    "          <li><a href=`"/california-overtime-deduction`">California</a></li>`n" +
    "          <li><a href=`"/obbba-overtime-calculator-texas`">Texas</a></li>`n" +
    "        </ul>`n" +
    "      </div>`n" +
    "      <div class=`"footer-col`">`n" +
    "        <h4>By Industry</h4>`n" +
    "        <ul>`n" +
    "          <li><a href=`"/nurses-overtime-tax-2025`">Nurses</a></li>`n" +
    "          <li><a href=`"/construction-workers-overtime-deduction`">Construction</a></li>`n" +
    "        </ul>`n" +
    "      </div>`n" +
    "      <div class=`"footer-col`">`n" +
    "        <h4>Company</h4>`n" +
    "        <ul>`n" +
    "          <li><a href=`"/about`">About Us</a></li>`n" +
    "          <li><a href=`"/contact`">Contact</a></li>`n" +
    "          <li><a href=`"/privacy-policy`">Privacy</a></li>`n" +
    "        </ul>`n" +
    "      </div>"
)
$newFooterIndex = (
    "      <div class=`"footer-col`">`n" +
    "        <h4>Guides</h4>`n" +
    "        <ul>`n" +
    "          <li><a href=`"/who-qualifies`">Who Qualifies</a></li>`n" +
    "          <li><a href=`"/how-to-find-overtime-on-w2`">W-2 Guide</a></li>`n" +
    "          <li><a href=`"/workforce-guide`">Workforce Guide</a></li>`n" +
    "          <li><a href=`"/state-tax-guide`">State Guide</a></li>`n" +
    "        </ul>`n" +
    "      </div>`n" +
    "      <div class=`"footer-col`">`n" +
    "        <h4>Company</h4>`n" +
    "        <ul>`n" +
    "          <li><a href=`"/about`">About Us</a></li>`n" +
    "          <li><a href=`"/contact`">Contact</a></li>`n" +
    "          <li><a href=`"/privacy-policy`">Privacy</a></li>`n" +
    "          <li><a href=`"/faq`">FAQ</a></li>`n" +
    "        </ul>`n" +
    "      </div>"
)
$opsD = @(
    # NAV 5% bigger (multi-line variants)
    @{ old='padding: 16px 0;';                                                                new='padding: 17px 0;' },
    @{ old="    font-weight: 800;`n    font-size: 22px;`n    color: var(--white);";           new="    font-weight: 800;`n    font-size: 23px;`n    color: var(--white);" },
    @{ old='{ .logo { font-size: 26px; } }';                                                  new='{ .logo { font-size: 27px; } }' },
    @{ old='{ .logo { font-size: 28px; } }';                                                  new='{ .logo { font-size: 29px; } }' },
    @{ old='  .nav { display: none; gap: 28px; align-items: center; }';                       new='  .nav { display: none; gap: 29px; align-items: center; }' },
    @{ old='  .nav a { color: var(--white); font-size: 14px; font-weight: 500; opacity: 0.85; transition: opacity 0.15s; }'; new='  .nav a { color: var(--white); font-size: 15px; font-weight: 500; opacity: 0.85; transition: opacity 0.15s; }' },
    @{ old="    padding: 8px 14px;`n    border-radius: 8px;";                                 new="    padding: 9px 15px;`n    border-radius: 8px;" },
    @{ old="    font-weight: 600;`n    font-size: 14px;`n    font-family: inherit;";          new="    font-weight: 600;`n    font-size: 15px;`n    font-family: inherit;" },
    # FOOTER CSS 5-col → 3-col
    @{ old='repeat(5, 1fr); } }';                                                             new='repeat(3, 1fr); } }' },
    # FOOTER HTML (multi-line)
    @{ old=$oldFooterIndex;                                                                    new=$newFooterIndex },
    # HERO 8% smaller
    @{ old='    padding: 56px 0 80px;';                                                       new='    padding: 52px 0 74px;' },
    @{ old='    padding: 6px 14px;';                                                          new='    padding: 5px 13px;' },
    @{ old="    margin-bottom: 20px;`n    border: 1px solid rgba(240, 165, 0, 0.3);";         new="    margin-bottom: 18px;`n    border: 1px solid rgba(240, 165, 0, 0.3);" },
    @{ old='    font-size: clamp(2rem, 6vw, 3.5rem);';                                        new='    font-size: clamp(1.84rem, 5.52vw, 3.22rem);' },
    @{ old='    font-size: clamp(1rem, 2.5vw, 1.18rem);';                                     new='    font-size: clamp(0.92rem, 2.3vw, 1.09rem);' },
    @{ old="    gap: 18px;`n    margin-top: 18px;";                                           new="    gap: 17px;`n    margin-top: 17px;" }
)
Write-Host "`nGroup D (index.html):"
Patch "$dir\index.html" $opsD

# ─────────────────────────────────────────────────────────────
# GROUP E: Hero 8% smaller — tips-calculator + paycheck-calculator
# (nav/footer already done in Group A, this adds the hero changes)
# ─────────────────────────────────────────────────────────────
$heroShared = @(
    @{ old='padding: 56px 0 80px;';                                                                              new='padding: 52px 0 74px;' },
    @{ old='padding: 6px 14px; border-radius: 999px;';                                                          new='padding: 5px 13px; border-radius: 999px;' },
    @{ old='margin-bottom: 20px; border: 1px solid rgba(240, 165, 0, 0.3); }';                                  new='margin-bottom: 18px; border: 1px solid rgba(240, 165, 0, 0.3); }' },
    @{ old='font-size: clamp(1rem, 2.5vw, 1.18rem);';                                                           new='font-size: clamp(0.92rem, 2.3vw, 1.09rem);' },
    @{ old='gap: 18px; margin-top: 18px; font-size: 13px;';                                                     new='gap: 17px; margin-top: 17px; font-size: 13px;' }
)
$heroTips    = $heroShared + @(@{ old='font-size: clamp(2rem, 6vw, 3.5rem);';    new='font-size: clamp(1.84rem, 5.52vw, 3.22rem);' })
$heroPaycheck= $heroShared + @(@{ old='font-size: clamp(2rem, 6vw, 3.4rem);';    new='font-size: clamp(1.84rem, 5.52vw, 3.13rem);' })

Write-Host "`nGroup E (hero — tips + paycheck):"
Patch "$dir\tips-calculator.html"    $heroTips
Patch "$dir\paycheck-calculator.html" $heroPaycheck

Write-Host "`n All done!"
