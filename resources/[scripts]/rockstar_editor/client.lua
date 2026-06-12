RegisterCommand("gravar", function()
    if IsRecording() then
        StopRecordingAndSaveClip() -- Para a gravação e salva o clipe
        print("📽️ Gravação salva no Rockstar Editor!")
    else
        StartRecording(1) -- Começa a gravação
        print("🎬 Gravação iniciada!")
    end
end, false)
