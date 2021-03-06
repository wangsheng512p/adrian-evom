*** Settings ***
Documentation   Test case to demonstrate SikuliX library keywords usage
...             Install first with 'pip install robotframework-sikulixlibrary'
...             The reference images from img directory are generated on 1440 x 900 virtual screen, regenerate them for different environment
...

# Library         SikuliXLibrary
# Initialize library with sikuli_path or use SIKULI_HOME environment variable (recommended)
Library         SikuliXLibrary  sikuli_path=sikulixide-2.0.5.jar
#Library         SikuliXLibrary  sikuli_path=/Home/eclipse/sikulix/sikulix.jar  image_path=  logImages=${True}  centerMode=${False}
Library         OperatingSystem


*** Variables ***
${IMAGE_DIR}        ${CURDIR}/img/Ubuntu
${DEFAULT_WAIT}     ${15}


*** Test Cases ***
Test Leafpad With SikuliX
    Set Log Level    TRACE
    log java bridge

    # local path for image files.
    imagePath add    ${IMAGE_DIR}

    set sikuli resultDir    ${OUTPUT DIR}
    Create Directory        ${OUTPUT DIR}/matches
    Create Directory        ${OUTPUT DIR}/screenshots

    region setAutoWait      ${DEFAULT_WAIT}
    # coordinates relative to upper left corner
    set offsetCenterMode    ${False}
    set notFoundLogImages   ${True}

    # for demo purpose
    settings setShowActions    ${True}
    ${prev}    settings set    Highlight            ${True}
    ${prev}    settings set    WaitAfterHighlight   ${0.9}

    # default min similarity
    ${prev}    settings set    MinSimilarity    ${0.9}

    # step 1
    log    Step1: open Leafpad
    
    # TODO: Enable after https://github.com/RaiMan/SikuliX1/issues/438 is fixed
    #app open     leafpad
    region wait  Leafpad

    #pass execution  .

    # step 2
    # message is Leafpad2 not found after removing path
    log    Step2: Leafpad2 image should not be found
    imagePath remove  ${IMAGE_DIR}
    region exists     Leafpad2

    # step 3
    log    Step3: Leafpad2 should be found after adding image path
    imagePath add    ${IMAGE_DIR}
    region exists    Leafpad2

    region paste    Welcome to the all new SikuliX RF library
    sleep  3

    # step 4
    log     Step4: delete all typed text and type new one
    region type    text=A    modifier=SikuliXJClass.Key.CTRL
    region type    SikuliXJClass.Key.DELETE

    region paste   Welcome to the all new SikuliX RF libraryy    Leafpad=0.7    14    60
    region wait    Leafpad typed
    region type    SikuliXJClass.Key.BACKSPACE

    # step 5
    log    Step5: get all region text by OCR
    ${text}     region text    Leafpad typed
    log  ${text}

    # step 6
    log    Step6: type new line and new text
    region type    SikuliXJClass.Key.ENTER

    ${py4j}  Get Environment Variable  SIKULI_PY4J  default=0
    Run Keyword If  '${py4j}' == '1'
    ...    region paste   Based on Py4J Python module
    ...    ELSE    region paste   Based on JPype Python module

    #${prev}    settings set    Highlight        ${False}

    # step 7
    log    Step7: search and highlight Untitled text
    ${found}    region existsText    *Untitled
    log  ${found}
    region highlight    3
    region highlightAllOff

    # step 8
    log    Step8: right click on Leafpad - will fail if SKIP is not used next
    region setFindFailedResponse    SKIP
    region rightClick    Leafpad    48    14
    sleep  3

    # step 9
    log    Step9: use correct image for right click
    region setFindFailedResponse    ABORT
    ${prev}    settings set    MinSimilarity    ${0.7}
    region rightClick    Leafpad typed    48    14

    # coordinates relative to upper left corner of the image
    #region click    Leafpad menu    54    80
    #app focus       Leafpad

    #region click    Leafpad typed    50    12
    # use previous found region
    #region rightClick    None    0    0    True

    # step 10
    #log    Step10: same as step 9, with coordinates relative to center
    # coordinates relative to center of the image
    #set offsetCenterMode    ${True}
    #region click    Leafpad menu    -10    10
    #app focus       Leafpad

    # step 11
    log    Step11: dragDrop Leafpad
    set offsetCenterMode    ${False}
    ${prev}    settings set    DelayBeforeDrop    ${2.0}
    region dragDrop    Leafpad typed  Leafpad typed    50    12    100    12

    # step 12
    log    Step12: delete everything and close Leafpad
    region type    text=A    modifier=SikuliXJClass.Key.CTRL
    region type    SikuliXJClass.Key.DELETE

    app close    leafpad
    destroy vm
