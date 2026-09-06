$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$htmlPath = Join-Path $repoRoot "ATL-Smart-Attendance-Production.html"

if (-not (Test-Path -LiteralPath $htmlPath)) {
    throw "ATL-Smart-Attendance-Production.html was not found at $htmlPath"
}

$html = Get-Content -LiteralPath $htmlPath -Raw -Encoding UTF8
$marker = "/* ATL sidebar redesign v2 */"

if ($html.Contains($marker)) {
    Write-Host "Sidebar redesign is already applied."
    exit 0
}

$css = @'

    /* ATL sidebar redesign v2 */
    /* Move the existing Admin sidebar to the LEFT without changing its
       IDs, event wiring, or context-switching logic. */
    #adminLayer .admin-body {
      display: flex !important;
      flex-direction: row !important;
      min-width: 0 !important;
      min-height: 0 !important;
      overflow: hidden !important;
    }

    #adminLayer .admin-main {
      order: 2 !important;
      flex: 1 1 0% !important;
      min-width: 0 !important;
      min-height: 0 !important;
      overflow: hidden !important;
    }

    #adminLayer .admin-side {
      order: 1 !important;
      flex: 0 0 252px !important;
      width: 252px !important;
      min-width: 252px !important;
      min-height: 0 !important;
      overflow-x: hidden !important;
      overflow-y: auto !important;
      border-left: 0 !important;
      border-right: 1px solid var(--hairline) !important;
      padding: 20px 16px 22px !important;
      box-sizing: border-box !important;
      background: rgba(242, 243, 246, 0.055) !important;
      backdrop-filter: blur(18px) saturate(1.2) !important;
      -webkit-backdrop-filter: blur(18px) saturate(1.2) !important;
      transform: translateX(-18px) !important;
      opacity: 0 !important;
      transition: transform 340ms var(--ease), opacity 220ms ease !important;
      scrollbar-width: thin !important;
      scrollbar-color: rgba(242, 243, 246, 0.16) transparent !important;
    }

    #adminLayer.open .admin-side {
      transform: translateX(0) !important;
      opacity: 1 !important;
    }

    #adminLayer .admin-side::-webkit-scrollbar {
      width: 3px !important;
    }

    #adminLayer .admin-side::-webkit-scrollbar-track {
      background: transparent !important;
    }

    #adminLayer .admin-side::-webkit-scrollbar-thumb {
      background: rgba(242, 243, 246, 0.16) !important;
      border-radius: 2px !important;
    }

    /* Global admin navigation: restrained editorial rail, left aligned. */
    #adminLayer #adminSide #adminNav {
      display: flex !important;
      flex-direction: column !important;
      align-items: stretch !important;
      gap: 2px !important;
      width: 100% !important;
      max-width: none !important;
      margin: 0 !important;
      padding: 0 !important;
      border: 0 !important;
      background: transparent !important;
    }

    #adminLayer #adminSide #adminNav button {
      width: 100% !important;
      min-height: 36px !important;
      padding: 8px 10px !important;
      border: 0 !important;
      border-radius: 3px !important;
      background: transparent !important;
      color: rgba(242, 243, 246, 0.58) !important;
      font-family: var(--sans) !important;
      font-size: 10px !important;
      font-weight: 400 !important;
      letter-spacing: 0.04em !important;
      text-align: left !important;
      text-transform: uppercase !important;
      justify-content: flex-start !important;
      box-shadow: none !important;
      cursor: pointer !important;
      transition: background 140ms ease, color 140ms ease, transform 180ms var(--ease) !important;
    }

    #adminLayer #adminSide #adminNav button:hover {
      background: rgba(242, 243, 246, 0.055) !important;
      color: #F2F3F6 !important;
    }

    #adminLayer #adminSide #adminNav button.active {
      background: rgba(242, 243, 246, 0.12) !important;
      color: #F2F3F6 !important;
      font-weight: 500 !important;
      transform: translateX(4px) !important;
    }

    /* Context area stays inside the same sidebar; only the active context
       is exposed by the existing updateTabs() behavior. */
    #adminLayer #adminSide .side-ctx {
      width: 100% !important;
      min-width: 0 !important;
      margin-top: 18px !important;
      padding-top: 18px !important;
      border-top: 1px solid var(--hairline) !important;
      background: transparent !important;
    }

    #adminLayer #adminSide .side-label {
      margin: 0 0 10px !important;
      font-family: var(--sans) !important;
      font-size: 9px !important;
      font-weight: 500 !important;
      letter-spacing: 0.08em !important;
      text-transform: uppercase !important;
      color: rgba(242, 243, 246, 0.48) !important;
    }

    /* Attendance controls: vertical, left-side settings panel. */
    #adminLayer #adminSide #sideCtx-attendance .seg-strip {
      display: flex !important;
      flex-direction: column !important;
      align-items: stretch !important;
      gap: 2px !important;
      width: 100% !important;
      margin: 0 !important;
      padding: 0 !important;
      border: 0 !important;
      background: transparent !important;
    }

    #adminLayer #adminSide #sideCtx-attendance .seg-btn {
      display: flex !important;
      align-items: center !important;
      justify-content: flex-start !important;
      width: 100% !important;
      min-height: 34px !important;
      padding: 7px 9px !important;
      border: 0 !important;
      border-radius: 3px !important;
      background: transparent !important;
      color: rgba(242, 243, 246, 0.62) !important;
      font-family: var(--sans) !important;
      font-size: 10.5px !important;
      font-weight: 400 !important;
      letter-spacing: 0.01em !important;
      text-align: left !important;
      box-shadow: none !important;
      cursor: pointer !important;
      transition: background 140ms ease, color 140ms ease !important;
    }

    #adminLayer #adminSide #sideCtx-attendance .seg-btn:hover {
      background: rgba(242, 243, 246, 0.055) !important;
      color: #F2F3F6 !important;
    }

    #adminLayer #adminSide #sideCtx-attendance .seg-btn.active {
      background: rgba(242, 243, 246, 0.12) !important;
      color: #F2F3F6 !important;
      font-weight: 500 !important;
    }

    #adminLayer #adminSide #sideCtx-attendance #attDatePreset {
      display: none !important;
    }

    #adminLayer #adminSide #sideCtx-attendance #attSingleDate,
    #adminLayer #adminSide #sideCtx-attendance #attFromDate,
    #adminLayer #adminSide #sideCtx-attendance #attToDate {
      width: 100% !important;
      height: 32px !important;
      padding: 4px 0 !important;
      margin-top: 6px !important;
      border: 0 !important;
      border-bottom: 1px solid rgba(242, 243, 246, 0.2) !important;
      border-radius: 0 !important;
      background: transparent !important;
      color: #F2F3F6 !important;
      font-family: var(--mono) !important;
      font-size: 10.5px !important;
      outline: none !important;
      color-scheme: light !important;
    }

    #adminLayer #adminSide #sideCtx-attendance #attSingleDate:focus,
    #adminLayer #adminSide #sideCtx-attendance #attFromDate:focus,
    #adminLayer #adminSide #sideCtx-attendance #attToDate:focus {
      border-bottom-color: #F2F3F6 !important;
    }

    #adminLayer #adminSide #sideCtx-attendance #attApplyBtn {
      margin-top: 12px !important;
      min-height: 32px !important;
      padding: 6px 9px !important;
      border: 1px solid rgba(242, 243, 246, 0.26) !important;
      border-radius: 3px !important;
      background: rgba(242, 243, 246, 0.08) !important;
      color: #F2F3F6 !important;
      font-family: var(--sans) !important;
      font-size: 9.5px !important;
      font-weight: 500 !important;
      letter-spacing: 0.05em !important;
      text-transform: uppercase !important;
      box-shadow: none !important;
      cursor: pointer !important;
    }

    #adminLayer #adminSide #sideCtx-attendance #attApplyBtn:hover {
      background: rgba(242, 243, 246, 0.14) !important;
      border-color: rgba(242, 243, 246, 0.42) !important;
    }

    /* Do not expose the former Attendance toolbar above the table.  The
       existing IDs remain intact for compatibility with ui_app.js. */
    #adminLayer #pane-attendance > .tab-toolbar {
      display: none !important;
    }

    @media (max-width: 860px) {
      #adminLayer .admin-side {
        flex-basis: 220px !important;
        width: 220px !important;
        min-width: 220px !important;
      }
    }

    @media (prefers-reduced-motion: reduce) {
      #adminLayer .admin-side {
        transition: none !important;
        transform: none !important;
        opacity: 1 !important;
      }
      #adminLayer #adminSide #adminNav button.active {
        transform: none !important;
      }
    }

    /* Dark-ink pole keeps layout unchanged and only flips text/surfaces. */
    html[data-ink="dark"] #adminLayer .admin-side {
      background: rgba(24, 26, 32, 0.055) !important;
      border-right-color: rgba(24, 26, 32, 0.14) !important;
      scrollbar-color: rgba(24, 26, 32, 0.16) transparent !important;
    }

    html[data-ink="dark"] #adminLayer #adminSide #adminNav button {
      color: rgba(24, 26, 32, 0.62) !important;
    }

    html[data-ink="dark"] #adminLayer #adminSide #adminNav button:hover,
    html[data-ink="dark"] #adminLayer #adminSide #adminNav button.active {
      background: rgba(24, 26, 32, 0.12) !important;
      color: #181A20 !important;
    }

    html[data-ink="dark"] #adminLayer #adminSide .side-ctx {
      border-top-color: rgba(24, 26, 32, 0.12) !important;
    }

    html[data-ink="dark"] #adminLayer #adminSide .side-label {
      color: rgba(24, 26, 32, 0.48) !important;
    }

    html[data-ink="dark"] #adminLayer #adminSide #sideCtx-attendance .seg-btn {
      color: rgba(24, 26, 32, 0.62) !important;
    }

    html[data-ink="dark"] #adminLayer #adminSide #sideCtx-attendance .seg-btn:hover,
    html[data-ink="dark"] #adminLayer #adminSide #sideCtx-attendance .seg-btn.active {
      background: rgba(24, 26, 32, 0.12) !important;
      color: #181A20 !important;
    }

    html[data-ink="dark"] #adminLayer #adminSide #sideCtx-attendance #attSingleDate,
    html[data-ink="dark"] #adminLayer #sideCtx-attendance #attFromDate,
    html[data-ink="dark"] #adminLayer #sideCtx-attendance #attToDate {
      color: #181A20 !important;
      border-bottom-color: rgba(24, 26, 32, 0.2) !important;
    }

    html[data-ink="dark"] #adminLayer #adminSide #sideCtx-attendance #attApplyBtn {
      border-color: rgba(24, 26, 32, 0.26) !important;
      background: rgba(24, 26, 32, 0.08) !important;
      color: #181A20 !important;
    }
'@

$needle = "`n  </style>"
$insertAt = $html.LastIndexOf($needle)
if ($insertAt -lt 0) {
    throw "Could not locate the final </style> tag in ATL-Smart-Attendance-Production.html"
}

$html = $html.Insert($insertAt, $css)
Set-Content -LiteralPath $htmlPath -Value $html -Encoding UTF8 -NoNewline

# Verify the patch landed and key compatibility anchors are still present.
$verify = Get-Content -LiteralPath $htmlPath -Raw -Encoding UTF8
$required = @(
    $marker,
    "#adminLayer .admin-body",
    "#adminLayer .admin-side",
    "#adminLayer #pane-attendance > .tab-toolbar",
    "#sideCtx-attendance",
    "attDatePreset",
    "attSingleDate",
    "attFromDate",
    "attToDate",
    "attApplyBtn"
)

foreach ($needle in $required) {
    if (-not $verify.Contains($needle)) {
        throw "Sidebar redesign verification failed: missing '$needle'"
    }
}

Write-Host "ATL sidebar redesign applied successfully."
Write-Host "The existing admin-side IDs and Attendance date-control IDs were preserved."
