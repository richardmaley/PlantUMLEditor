unit PlantUMLHtml;

interface

Function InitHtml(FileName: String): Boolean;

implementation
Uses
  WinApi.Windows,
  ads.FileNew,
  ads.Globals,
  System.Classes,
  System.SysUtils,
  Vcl.Forms;

Const Html=
  '''''
  <!DOCTYPE html>
  <html lang="en">
     <head>
        <link rel="preconnect" href="//editor.plantuml.com" crossorigin>
        <script>(function(){function storageAvailable(type){var storage;try{storage=window[type];var x='__storage_test__';storage.setItem(x,x);storage.removeItem(x);return true;}
           catch(e){return e instanceof DOMException&&(e.code===22||e.code===1014||e.name==='QuotaExceededError'||e.name==='NS_ERROR_DOM_QUOTA_REACHED')&&(storage&&storage.length!==0);}}
           function remove_ama_config(){if(storageAvailable('localStorage')){localStorage.removeItem("google_ama_config");}}
           remove_ama_config()})()
        </script>
        <base href="https://editor.plantuml.com/SoWkIImgAStDuNBAJrBGjLDmpCbCJbMmKiX8pSd9vt98pKi1IW80">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="shortcut icon" href="https://plantuml.com/favicon.ico">
        <title>PlantUML Editor</title>
        <style>
           /* Ensure html and body take up full height and width */
           html, body {
           margin: 0;
           padding: 0;
           height: 100%;
           width: 100%;
           overflow: hidden; /* Prevent scrolling */
           }
           /* Ensure the external container takes up full height */
           #external_container {
           display: flex;
           flex-direction: column;
           height: 97vh; /* Use 97% of the viewport height */
           overflow: hidden;
           }
           /* Ensure the container takes up the remaining height */
           #container {
           display: flex;
           flex: 1;
           min-height: 0; /* Allow the container to shrink */
           height: 100%; /* Take up the full height */
           width: 100%;
           overflow: hidden;
           }
           /* Ensure the editor takes up available space */
           #editor {
           flex-grow: 1;
           flex-shrink: 1;
           width: calc(50% - 160px);
           min-width: 200px;
           }
           /* Ensure the resizer is properly positioned */
           #resizer {
           width: 5px;
           background-color: #f1f1f1;
           cursor: col-resize;
           }
           /* Ensure the image container takes up available space */
           #image-container {
           flex-grow: 1;
           flex-shrink: 1;
           padding: 10px;
           overflow: auto;
           }
           /* Ensure the footer stays at the bottom and takes minimal height */
           #footer {
           margin: 0;
           padding: 10px;
           flex-shrink: 0; /* Prevent the footer from shrinking */
           }
           /* Dark Mode Styles */
           body.dark-mode {
           background-color: #1b1b1b;
           color: #ffffff;
           }
           body.dark-mode a {
           color: #48a9e0;
           }
           body.dark-mode a:hover, body.dark-mode a:focus {
           color: #76c7f4;
           }
           body.dark-mode #header {
           background-color: #313139;
           }
           body.dark-mode #resizer {
           background-color: #313139;
           }
           body.dark-mode #footer {
           background-color: #1e1e1e;
           }
           body.dark-mode table {
           background-color: #1e1e1e;
           color: #ffffff;
           border: 1px solid #444;
           }
           body.dark-mode table button {
           background-color: #444;
           color: #ffffff;
           }
           body.dark-mode tbody tr:hover {
           background-color: #333;
           }
           body.dark-mode #encoded-input {
           background-color: #333;
           color: #ffffff;
           border: 1px solid #444;
           }
           body.dark-mode .decode-btn, body.dark-mode .btn {
           background-color: #444;
           color: #ffffff;
           border: 1px solid #444;
           }
           body.dark-mode .decode-btn:hover, body.dark-mode .btn:hover {
           background-color: #777;
           }
           /* Dark mode styles for back-div and load-div */
           body.dark-mode #back-div {
           background-color: rgba(0, 0, 0, 0.7); /* Slightly darker transparent background for dark mode */
           }
           body.dark-mode #load-div {
           background-color: #2a2a2a; /* Dark background for the load div */
           border: 1px solid #555; /* Darker border for the load div */
           box-shadow: 0 2px 4px rgba(0, 0, 0, 0.5); /* A more subtle shadow for dark mode */
           }
           a {
           color: #007bff;
           text-decoration: none;
           }
           a:hover, a:focus {
           color: #0056b3;
           text-decoration: underline;
           }
           #header {
           background-color: #f8f7e3;
           border: 2px solid #d6d1ab;
           padding: 10px;
           margin: 10px;
           text-align: center;
           border-radius: 8px;
           box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
           }
           #cola, #colb {
           flex-grow: 0;
           flex-shrink: 1;
           }
           #image-container img {
           max-width: 100%;
           height: auto;
           }
        </style>
        <style>
           table {
           width: 100%;
           margin: 1px auto;
           border-collapse: collapse;
           border: 1px solid #ddd;
           border-radius: 5px;
           box-shadow: 0 4px 8px rgba(0,0,0,0.1);
           }
           th, td {
           padding: 1px 5px;
           text-align: left;
           border-bottom: 1px solid #ddd;
           cursor: pointer;
           }
           tbody tr:hover {
           background-color: #f1f1f1;
           }
           table button {
           padding: 1px;
           background-color: #f6f8fa; /* Lighter grey */
           color: #24292e; /* Dark text color */
           border: 1px solid #d1d5da; /* Light grey border */
           border-radius: 6px;
           cursor: pointer;
           margin: 0;
           }
           table button:hover {
           background-color: #e1e4e8; /* Slightly darker on hover */
           }
        </style>
        <style>
           /* Style for the text area */
           #encoded-input {
           width: 100%;
           padding: 2px;
           font-size: 14px;
           border: 1px solid #ccc;
           border-radius: 4px;
           box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.1);
           }
           /* Apply the flex layout to the container */
           .tooltip-container {
           display: flex;
           align-items: center; /* Vertically align the elements */
           position: relative;
           }
           /* Style for the input */
           #encoded-input {
           flex-grow: 1; /* Allow the input to take up as much space as possible */
           margin-right: 10px; /* Space between the encoded input and the Decode button */
           }
           /* Style for the Decode button */
           .decode-btn, .btn {
           padding: 4px 8px;
           background-color: #f6f8fa; /* Lighter grey */
           color: #24292e; /* Dark text color */
           border: 1px solid #d1d5da; /* Light grey border */
           border-radius: 6px;
           cursor: pointer;
           font-size: 14px;
           }
           .decode-btn {
           white-space: nowrap;
           }
           /* Style for the copy button */
           .btn {
           margin: 10px 0; /* Adds some spacing above and below */
           }
           .btn:hover,.decode-btn:hover {
           background-color: #e1e4e8; /* Slightly darker on hover */
           }
           /* Style for the delete button */
           .delete-btn {
           padding: 2px 8px;
           background-color: #f6f8fa; /* Lighter grey */
           color: #24292e; /* Dark text color */
           border: 1px solid #d1d5da; /* Light grey border */
           border-radius: 6px;
           cursor: pointer;
           font-size: 14px;
           margin: 2px 0; /* Adds some spacing above and below */
           }
           .delete-btn:hover {
           background-color: #e1e4e8; /* Slightly darker on hover */
           }
        </style>
        <style>
           /* Styles for the background overlay */
           #back-div {
           position: fixed;
           top: 0;
           left: 0;
           width: 100%;
           height: 100%;
           background-color: rgba(0, 0, 0, 0.5); /* Transparent dark background */
           z-index: 999; /* Back div behind load_div */
           }
           /* Styles for the file loader div */
           #load-div {
           position: absolute;
           top: 50%;
           left: 50%;
           transform: translate(-50%, -50%);
           background-color: white; /* Light background */
           border: 1px solid #ccc;
           padding: 20px; /* Increase padding for a larger look */
           box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
           width: 70%;  /* Increased width */
           height: 60%; /* Increased height */
           overflow-y: auto; /* Add scroll if content overflows vertically */
           z-index: 1000; /* Ensure the div is in the foreground */
           }
           /* Style for the delete button */
           .delete-btn {
           cursor: pointer;
           }
        </style>
        <style>
           .ace_style {
           color: #111;
           }
           .dark-mode .ace_style {
           color: #eee;
           }
           .ace_keyword2 {
           color: #333;
           font-weight: bold;
           }
           .dark-mode .ace_keyword2 {
           color: #E0E0E0;
           }
           .ace_preprocessor {
           color: #22863a;
           font-weight: bold;
           }
           .dark-mode .ace_preprocessor {
           color: #79b8ff;
           font-weight: bold;
           }
           .ace_keyword {
           color: #b31d28;
           }
           .ace_identifier {
           color: #0366d6;
           }
           .dark-mode .ace_identifier {
           color: #539bf5;
           }
           .ace_bracket {
           font-weight: bold;
           }
           .topbutton{
           height:25px;
           width:125px;
           padding: 4px 8px;
           background-color: #f6f8fa; /* Lighter grey */
           color: #24292e; /* Dark text color */
           border: 1px solid #d1d5da; /* Light grey border */
           border-radius: 6px;
           cursor: pointer;
           font-size: 14px;
          }
        </style>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/ace/1.4.14/ace.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/ace/1.4.14/ext-language_tools.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/pako/2.0.4/pako.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/brython@3.12.2/brython.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/brython@3.12.2/brython_stdlib.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.3/css/jquery.dataTables.min.css">
     </head>
     <body onload="brython()">
      <div id="not_ace_container">
            <!-- Button to load with an icon -->
            <button class="topbutton" id="load-file-btn" name="load-file-btn" width="100px" Title="Load a diagram from file">
            <i class="fas fa-folder-open"></i> Select File
            </button>
            &nbsp;&nbsp;&nbsp;
          <label style="font-family: sans-serif,Helvetica,Arial;font-size: 14px;" for="filepath">File Path:</label>
          <input style="font-family: sans-serif,Helvetica,Arial;font-size: 14px;" type="text" id="filepath" name="filepath"  maxlength="200" size="100" readonly>
      </div>
      <div id="external_container">
           <div id="container">
              <div id="cola">
              </div>
              <div id="editor"></div>
              <div id="resizer"></div>
              <div id="image-container">
                 <img id="diagram-image" src="" style="display: none;" alt="">
              </div>
              <div id="colb">
              </div>
           </div>
           <div id="footer">
              <!-- Button to copy the text with an icon -->
              <button class="btn" id="copy-btn" Title="Copy the editor contents to the clipboard">
              <i class="fas fa-copy"></i> Copy
              </button>
              <!-- Button to paste the text with an icon -->
              <button class="btn" id="paste-btn" Title="Paste the clipboard contents into the editor">
              <i class="fas fa-paste"></i> Paste
              </button>
              <!-- Button to save with an icon -->
              <button class="btn" id="save-btn" Title="Save the current diagram">
              <i class="fas fa-save"></i> Save
              </button>
              <!-- Button to load with an icon -->
              <button class="btn" id="load-btn" Title="Select a diagram">
              <i class="fas fa-folder-open"></i> List
              </button>
              <!-- Toggle Button for Dark/Light Mode -->
              <button class="btn" id="toggle-mode-btn" Title="Toggle Light/Dark Theme">
              <i class="fas fa-adjust"></i> Mode
              </button>
              <!-- New Button to Update URL with an icon -->
              <button class="btn" id="update-url-btn" hidden="hidden">
              <i class="fas fa-link"></i> SyncURL
              </button>
              <!-- New Button to Open a New Window with an icon -->
              <button class="btn" id="open-window-btn" hidden="hidden">
              <i class="fas fa-external-link"></i> Open Window
              </button>
              <!-- Hyperlink to PNG image -->
              <a href="" target="_blank" id="png-link" title="Save the diagram as a PNG Image" style="margin-left: 25px;"><i class="fas fa-image"></i></a>
              <!-- Hyperlink to SVG image -->
              <a href="" target="_blank" id="svg-link" title="Save the diagram as a SVG Image" style="margin-left: 15px;"><i class="fas fa-vector-square"></i></a>
              <!-- Hyperlink to ASCII Art image -->
              <a href="" target="_blank" id="ascii-link" title="Save the diagram as ASCII Art" style="margin-left: 15px;"><i class="fas fa-font"></i></a>
              <div class="tooltip-container">
                 <input id="encoded-input" type="text" value="">
                 <button class="decode-btn" id="decode-btn">
                 <i class="fas fa-unlock-alt"></i> Decode
                 </button>
              </div>
           </div>
        </div>

        <script>
           ace.define("ace/mode/plantuml", ["require", "exports", "ace/lib/oop", "ace/mode/text", "ace/mode/text_highlight_rules"], function(acequire, exports) {
               var oop = acequire("ace/lib/oop");
               var TextMode = acequire("ace/mode/text").Mode;
               var TextHighlightRules = acequire("ace/mode/text_highlight_rules").TextHighlightRules;

               function PlantUMLHighlightRules() {
                   this.$rules = {
                       "start": [
                           { token: "style", regex: "^\\<style\\>", next: "style" },
                           { token: "comment", regex: "^\\s*'.*" },
                           { token: "comment", regex: "/'", next: "comment" },
                           { token: "keyword2", regex: "@startuml|@enduml" },
                           { token: "keyword", regex: "[-+<>=]+" },
                           { token: "keyword", regex: "\\b(abstract|action|actor|agent|annotation|archimate|artifact|boundary|card|class|cloud|collections|component|control|database|diamond|entity|enum|exception|file|folder|frame|hexagon|interface|json|label|map|metaclass|node|object|package|participant|person|process|protocol|queue|rectangle|relationship|stack|state|storage|struct|usecase)\\b" },
                           { token: "keyword", regex: "\\b(across|activate|again|allow_mixing|allowmixing|also|alt|as|attribute|attributes|autonumber|bold|bottom|box|break|caption|center|circle|circled|circles|color|create|critical|dashed|deactivate|description|destroy|detach|dotted|down|else|elseif|empty|end|endcaption|endfooter|endheader|endif|endlegend|endtitle|endwhile|false|field|fields|footbox|footer|fork|group|header|hide|hnote|if|is|italic|kill|left|left to right direction|legend|link|loop|mainframe|member|members|method|methods|namespace|newpage|normal|note|of|on|opt|order|over|package|page|par|partition|plain|private|protected|public|ref|repeat|return|right|rnote|rotate|show|skin|skinparam|split|sprite|start|stereotype|stereotypes|stop|style|then|title|together|top|top to bottom direction|true|up|while)\\b" },
                           { token: "string", regex: '".*?"' },
                           { token: "preprocessor", regex: "^![a-zA-Z_]+" },
                           { token: "bracket", regex: "[{}\\[\\]]" },
                           { token: "identifier", regex: "\\$[a-zA-Z_][a-zA-Z0-9_]*\\b" },
                           { token: "constant.numeric", regex: "\\b[0-9]+" }
                       ],
                       "style": [
                           { token: "style", regex: "^\\</style\\>", next: "start" },
                           { token: "style", regex: ".+" }
                       ],
                       "comment": [
                           { token: "comment", regex: ".*?'/", next: "start" },
                           { token: "comment", regex: ".+" }
                       ]
                   };
                   this.normalizeRules();

               }
               oop.inherits(PlantUMLHighlightRules, TextHighlightRules);

               function PlantUMLMode() {
                   this.HighlightRules = PlantUMLHighlightRules;
                   this.blockComment = { start: "/'", end: "'/" };
               }
               oop.inherits(PlantUMLMode, TextMode);

               exports.Mode = PlantUMLMode;
           });

           ace.edit("editor").session.setMode("ace/mode/plantuml");
           if (window.localStorage.getItem("toggle_mode") === "dark") {
               document.body.classList.toggle("dark-mode");
               ace.edit("editor").setTheme("ace/theme/dracula");
           } else {
               ace.edit("editor").setTheme("ace/theme/github");
           }
        </script>
        <script type="text/python">
           from browser import document, window, html, timer
           import re

           external_win = None

           def encode6bit(b):
               if b < 10:
                   return chr(48 + b)
               if b < 36:
                   return chr(65 + (b - 10))
               if b < 62:
                   return chr(97 + (b - 36))
               return '-' if b == 62 else '_'

           def append3bytes(b1, b2, b3):
               c1 = b1 >> 2
               c2 = ((b1 & 0x3) << 4) | (b2 >> 4)
               c3 = ((b2 & 0xF) << 2) | (b3 >> 6)
               c4 = b3 & 0x3F
               return encode6bit(c1 & 0x3F) + encode6bit(c2 & 0x3F) + encode6bit(c3 & 0x3F) + encode6bit(c4 & 0x3F)

           def encode64(data):
               r = ""
               i = 0
               while i < len(data):
                   if i + 2 == len(data):
                       r += append3bytes(data[i], data[i + 1], 0)
                   elif i + 1 == len(data):
                       r += append3bytes(data[i], 0, 0)
                   else:
                       r += append3bytes(data[i], data[i + 1], data[i + 2])
                   i += 3
               return r


           def decode64(data):
               r = ""
               i = 0
               while i < len(data):
                   b1 = decode6bit(data[i])
                   b2 = decode6bit(data[i + 1])
                   b3 = decode6bit(data[i + 2])
                   b4 = decode6bit(data[i + 3])

                   c1 = (b1 << 2) | (b2 >> 4)
                   c2 = ((b2 & 0xF) << 4) | (b3 >> 2)
                   c3 = ((b3 & 0x3) << 6) | b4

                   r += chr(c1)
                   if b3 != 64:
                       r += chr(c2)
                   if b4 != 64:
                       r += chr(c3)

                   i += 4

               return r

           def decode6bit(c):
               if '0' <= c <= '9':
                   return ord(c) - 48
               if 'A' <= c <= 'Z':
                   return ord(c) - 65 + 10
               if 'a' <= c <= 'z':
                   return ord(c) - 97 + 36
               return 62 if c == '-' else 63 if c == '_' else 64  # Padding character

           def compress_and_encode(data):
               byte_array = window.TextEncoder.new("utf-8").encode(data)
               compressed = window.pako.deflateRaw(byte_array)
               compressed_list = list(compressed)  # Direct conversion to list
               return encode64(compressed_list)


           def decompress_and_decode(data):
               decoded_base64 = decode64(data)
               # Convert the decoded string into a byte array
               byteArray = window.Uint8Array.new([ord(c) for c in decoded_base64])
               inflated = window.pako.inflateRaw(byteArray)
               return window.TextDecoder.new("utf-8").decode(inflated)


           # Function to retrieve URL parameters
           def get_url_param(param_name):
               url_params = window.location.search
               params = dict(p.split('=') for p in url_params[1:].split('&') if '=' in p)
               return params.get(param_name, None)

           match = re.search(r'[-_0-9A-Za-z]{20,}', window.location.href)
           if match:
               text_diagram_encoded = match.group(0)
           else:
               text_diagram_encoded = "SoWkIImgAStDuNBCoKnELT2rKt3AJrAmKiX8pSd9vt98pKi1IG80"

           plantuml_server = "https://img.plantuml.biz"

           def image_update(encoded):
               global external_win
               document["encoded-input"].value = encoded
               is_dark_mode = 'dark-mode' in document.body.classList
               suffix = 'd' if is_dark_mode else ''
               img_url = f"{plantuml_server}/plantuml/{suffix}png/{encoded}"
               document["png-link"].attrs['href'] = img_url
               document["svg-link"].attrs['href'] = f"{plantuml_server}/plantuml/{suffix}svg/{encoded}"
               document["ascii-link"].attrs['href'] = f"{plantuml_server}/plantuml/txt/{encoded}"

               def on_image_load(event):
                   width = img_element.width
                   height = img_element.height
                   print(f"{width=} {height=}")

               if external_win and not external_win.closed:
                   img_element = external_win.document.getElementById("external-image")
                   img_element.src = img_url
                   #print(external_win.document["external-image"])
                   #img_element = external_win.document["external-image"]
               else:
                   img_element = document["diagram-image"]
                   img_element.bind("load", on_image_load)
                   img_element.attrs['src'] = img_url
                   img_element.style['display'] = 'block'  # set visible



           # Display or use the retrieved value
           text_diagram = decompress_and_decode(text_diagram_encoded)

           image_update(text_diagram_encoded)

           # Using custom mode in the ACE editor
           editor = window.ace.edit("editor")

           # Set the initial content
           editor.setValue(text_diagram, 1)   # The second argument places the cursor at the end of the content

           # Optional settings
           editor.setOptions({
               "fontSize": "10pt",
               "showLineNumbers": True,
               "tabSize": 4
           })

           # Variable to store the timer ID
           timeout_id = None

           def editor_change(*args):
               global timeout_id
               # Retrieve the value from the editor
               v = editor.getValue()
               if len(v)>0:
                   encoded = compress_and_encode(v)
                   print(f"editor_change {len(v)=} {encoded=}")
                   document["encoded-input"].value = encoded
                   if timeout_id:
                       timer.clear_timeout(timeout_id)

                   timeout_id = timer.set_timeout(lambda: image_update(encoded), 1500)


           # Bind the change event to the editor_change function
           editor.session.on('change', editor_change)

           # Resize logic
           resizer = document["resizer"]
           editorDiv = document["editor"]
           imageContainer = document["image-container"]

           def resize(event):
               containerRect = document["container"].getBoundingClientRect()
               colaRect = document["cola"].getBoundingClientRect()

               newWidth = event.clientX - containerRect.left - colaRect.width

               editorDiv.style.width = f'{newWidth}px'

           def stopResize(event):
               document.unbind('mousemove', resize)
               document.unbind('mouseup', stopResize)

           def startResize(event):
               event.preventDefault()
               document.bind('mousemove', resize)
               document.bind('mouseup', stopResize)

           resizer.bind('mousedown', startResize)


           # Function that will be called when the encoded value changes
           def click_on_decode(event):
               input_value = document["encoded-input"].value
               # Check if a slash is present and retrieve the text after the last slash
               if '/' in input_value:
                   input_value = input_value.rpartition('/')[-1]  # Take the part after the last slash

               print(f"on_encoded_input_change {input_value=}")
               uml = decompress_and_decode(input_value)
               print(f"on_encoded_input_change {uml=}")
               editor.setValue(uml)


           # Bind the function to the 'click' event of the "Decode" button
           document["decode-btn"].bind("click", click_on_decode)

           # Function to copy the diagram text to the clipboard
           def copy_to_clipboard(event):
               editor_value = window.ace.edit("editor").getValue()  # Get the text from the editor
               window.navigator.clipboard.writeText(editor_value)  # Copy to the clipboard

           # Bind the copy_to_clipboard function to the "Copy" button
           document["copy-btn"].bind("click", copy_to_clipboard)

           # Function to toggle dark/light mode
           def toggle_mode(event):
               document.body.classList.toggle("dark-mode")
               # Update ACE editor theme based on the mode
               if 'dark-mode' in document.body.classList:
                   editor.setTheme("ace/theme/dracula")
                   window.localStorage.setItem("toggle_mode", "dark")
               else:
                   editor.setTheme("ace/theme/github")
                   window.localStorage.setItem("toggle_mode", "light")

               # Re-update the diagram image source based on the encoded value
               current_encoded = document["encoded-input"].value
               image_update(current_encoded)

           # Bind the function to the 'click' event of the toggle button
           document["toggle-mode-btn"].bind("click", toggle_mode)

           # Function to sync url
           def update_url(event):
               url = window.location.href
               print(f"{url=}")
               base_url_parts = url.split("/", 3)
               base_url = "/".join(base_url_parts[:3])
               if window.location.href.startswith("https://"):
                   window.location.href = f"https://editor.plantuml.com/uml/" + document["encoded-input"].value
               else:
                   window.location.href = f"{base_url}/?uml=" + document["encoded-input"].value

           # Bind the function to the 'click' event of the toggle button
           document["update-url-btn"].bind("click", update_url)

           def open_window(event):
               global external_win
               if external_win and not external_win.closed:
                   img_url = external_win.document.getElementById("external-image").src
                   external_win.close()
                   external_win = None
                   document["image-container"].style['display'] = 'block'
                   document["editor"].style.width = f'{round(window.innerWidth/2-160)}px'
                   document["diagram-image"].attrs['src'] = img_url
                   return

               w = round(window.innerWidth * .75)
               h = round(window.innerHeight * .75)
               options = f"width={w},height={h},toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,copyhistory=no"

               document["image-container"].style['display'] = 'none'
               document["editor"].style.width = f'{window.innerWidth - 20}px'

               img_url = document["diagram-image"].attrs['src']

               external_win = window.open('', '_blank', options)

               html_content = f'''
               <html>
               <body>
               <img id="external-image" src="{img_url}">
               </body>
               </html>
               '''

               external_win.document.write(html_content)
               external_win.document.close()

           document["open-window-btn"].bind("click", open_window)

           # Function to paste the clipboard text into the editor
           def paste_from_clipboard(event):
               # Use the clipboard API to read the text
               window.navigator.clipboard.readText().then(paste_text)

           # Function that pastes the retrieved text into the editor
           def paste_text(text):
               editor = window.ace.edit("editor")  # Retrieve the ACE editor
               editor.setValue(text, 1)  # Overwrite all content with the clipboard text, and place the cursor at the end

           # Bind the paste_from_clipboard function to the "Paste" button
           document["paste-btn"].bind("click", paste_from_clipboard)

           def save_file(event):
               # Generate an encoded date in the format YYYY_MM_DD__HH_MM_SS with JavaScript
               current_time = window.Date.new().toISOString().replace(":", "_").replace("-", "_").split(".")[0].replace("T", "__")

               # Propose the encoded date as the default file name
               filename = window.prompt("This will be saved locally in your browser:", f"diagram_{current_time}")

               if filename:
                   # Retrieve the content from the editor
                   editor_value = window.ace.edit("editor").getValue()
                   print(editor_value)
                   # Save in LocalStorage with the key provided by the user
                   window.localStorage.setItem("pl_" + filename, editor_value)

                   # Confirmation of the save
                   print(f"Content saved under the key : {filename}")

           # Bind the save_file function to the "Save" button
           document["save-btn"].bind("click", save_file)


           def load_file(event):
               # Retrieve all keys that start with "pl_"
               keys = [window.localStorage.key(i) for i in range(window.localStorage.length) if window.localStorage.key(i).startswith("pl_")]

               if not keys:
                   window.alert("Nothing to reload.")
                   return

               # Sort the keys alphabetically, including the "pl_" prefix
               keys.sort()  # Sort directly, including the 'pl_' prefix

               # Create a background div that covers the entire page
               back_div = document.createElement('div')
               back_div.id = "back-div"

               # Function to close both divs when clicking on back_div
               def close_on_click(event):
                   back_div.remove()
                   load_div.remove()

               # Bind click event to back_div to close it when clicked
               back_div.bind("click", close_on_click)

               # Add the back_div to the document
               document.body <= back_div

               # Create a dynamic div to display the key options
               load_div = document.createElement('div')
               load_div.id = "load-div"

               # Insert table instead of buttons
               load_div.innerHTML = "<strong>Available Files</strong><br><br>"

               table = html.TABLE()
               table_body = html.TBODY()

               # Add rows for each file
               for i, key in enumerate(keys):
                   row = html.TR()

                   # Delete button column
                   delete_button = html.BUTTON(Class="delete-btn")
                   delete_button <= html.I(Class="fas fa-trash")  # Add Font Awesome trash icon inside the button
                   delete_button.bind("click", lambda ev, k=key: delete_file(k))
                   delete_col = html.TD(delete_button)
                   delete_col.style.width = "1%"  # Set a small width for the delete column

                   # File name column
                   file_col = html.TD()
                   file_name_span = html.SPAN(key[3:])
                   file_col.bind("click", lambda ev, k=key: load_key(k))  # Bind click event to the span
                   file_col <= file_name_span  # Add span to the file_col

                   # Append columns to row
                   row <= delete_col
                   row <= file_col

                   # Append row to the table body
                   table_body <= row

               # Append table body to the table
               table <= table_body

               # Add table to load_div
               load_div <= table

               # Add the div to the document
               document.body <= load_div

           def delete_file(chosen_key):
               # Delete the file from LocalStorage
               window.localStorage.removeItem(chosen_key)

               # Reload the div to reflect the changes
               document["load-div"].remove()
               load_file(None)


           def load_key(chosen_key):
               # Load the value associated with the chosen key
               editor_value = window.localStorage.getItem(chosen_key)

               # Reload the value into the editor
               window.ace.edit("editor").setValue(editor_value)
               print(f"Content loaded from the key : {chosen_key}")

               # Remove the div after loading the data
               document["load-div"].remove()
               document["back-div"].remove()

           # Bind the load_file function to the "Load" button
           document["load-btn"].bind("click", load_file)
           def check_external_win():
               global external_win
               if external_win and external_win.closed and document["image-container"].style['display'] == 'none':
                   img_url = external_win.document.getElementById("external-image").src
                   external_win = None
                   document["image-container"].style['display'] = 'block'
                   document["editor"].style.width = f'{round(window.innerWidth/2-160)}px'
                   document["diagram-image"].attrs['src'] = img_url

           # Only solution to restore image when closing the external window
           timer.set_interval(check_external_win, 1000)

        </script>
      <!-- Add a hidden file input element -->
      <input type="file" id="file-input" style="display: none;" accept=".puml,.pu,.plantuml,.iuml">

      <script>
          // Function to load and display a PlantUML diagram from a known file path
          function loadPlantUMLDiagram(filePath) {
              fetch(filePath)
                  .then(response => {
                      if (!response.ok) {
                          // If the file does not exist, fail silently
                          return;
                      }
                      return response.text();
                  })
                  .then(content => {
                      if (content) {
                          // Set the content in the editor
                          const editor = window.ace.edit("editor");
                          editor.setValue(content, 1); // Overwrite all content with the file content, and place the cursor at the end
                          // Update the PlantUML diagram
                          image_update(text_diagram_encoded);
                      }
                  })
                  .catch(error => {
                      // Handle any errors silently
                      console.error('Error loading file:', error);
                  });
          }

          // Function to handle file selection
          function handleFileSelect(event) {
              const fileInput = document.getElementById('file-input');
              fileInput.click(); // Trigger the file input dialog
          }

          // Function to read the selected file
          function readFile(event) {
              const file = event.target.files[0];
              if (file) {
                  const reader = new FileReader();
                  reader.onload = function(e) {
                      const content = e.target.result;
                      // Set the content in the editor
                      const editor = window.ace.edit("editor");
                      editor.setValue(content, 1); // Overwrite all content with the file content, and place the cursor at the end
                      // Update the filepath input field with the file name
                      document.getElementById('filepath').value = file.name;
                  };
                  reader.readAsText(file);
              }
              image_update(text_diagram_encoded);
          }

      function getPlantUmlFile_Code() {
        let content = "";
        const editor = window.ace.edit("editor");
        PlantUmlFile.Code=editor.getValue(content, 1);
        console.log(PlantUmlFile.Code);
        return PlantUmlFile.Code;
      }

      function getPlantUmlFile_FileName() {
        const filePathInput = document.getElementById('filepath');
        PlantUmlFile.FileName=filePathInput.value;
        return PlantUmlFile.FileName;
      }

      function getPlantUmlFile() {
      PlantUmlFile.Title="PlantUmlFile";
        getPlantUmlFile_Code();
        getPlantUmlFile_FileName();
        console.log(PlantUmlFile);
        return PlantUmlFile;
      }

      function clickCopyButton() {
        var copyButton = document.getElementById('copy-btn');
        if (copyButton) {
          copyButton.click();
        } else {
          console.error('Copy button not found!');
        }
      }

      function copyFilePathToClipboard() {
        var filePathInput = document.getElementById('filepath');
        console.error('copyFilePathToClipboard atthe top');
        if (filePathInput) {
          filePathInput.select();
          filePathInput.setSelectionRange(0, 99999); // For mobile devices
          document.execCommand('copy');
        } else {
          console.error('File path input not found!');
        }
      }

      const PlantUmlFile = {
      Title: "PlantUmlFile",
        FileName: "",
        Code: ""
      };

      function SendPlantUmlFileToDelphi() {
        getPlantUmlFile();
      var message = JSON.stringify(PlantUmlFile);
        function tryPostMessage(message) {
            if (window.chrome.webview && window.chrome.webview.postMessage) {
                window.chrome.webview.postMessage(message); // Send the message back to the Delphi application
            } else {
                setTimeout(function() {
                    tryPostMessage(message);
                }, 100); // Retry after 100 milliseconds
            }
        }

        if (message) {
            tryPostMessage(message);
        }
      }

      // Bind the file input change event to the readFile function
      document.getElementById('file-input').addEventListener('change', readFile, false);

      // Bind the handleFileSelect function to the "load-file-btn" button
      document.getElementById('load-file-btn').addEventListener('click', handleFileSelect, false);

      </script>
     </body>
  </html>
  ''''';

Function InitHtml(FileName: String): Boolean;
Var
  lst: TStringlist;
  sgDir: String;
  sgDt: String;
Begin
  Result:=False;
  If Trim(FileName)='' Then Exit;
  sgDT := FormatDateTime('YYYYMMDDHHNNSS',now());
  BackupIfNeeded(FileName,DirBackup);

  If Not FileExists(FileName) Then
  Begin
  sgDir:=ExtractFilePath(FileName);
  Try
    If Not System.SysUtils.DirectoryExists(sgDir) Then
      System.SysUtils.ForceDirectories(sgDir);
  Except
    Exit;
  End;
  lst:=TStringList.create();
  Try
    lst.SetText(PChar(Html));
    Try
      lst.SaveToFile(FileName);
      Result:=True;
    Except
      Exit;
    End;
  Finally
    FreeAndNil(lst);
  End;
  End;
End;

end.
