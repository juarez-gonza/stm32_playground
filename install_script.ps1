function chocoInstallIfNotFound() {
	param(
		[String]$programName,
		[String]$packageName,
		[String]$chocoParameters
	)

	if ((Get-Command $programName -ErrorAction SilentlyContinue) -eq $null) {
		Write-Host "$programName was not found in your path... installing cmake with chocolatey"
		choco install $packageName $chocoParameters
		refreshenv
		Get-Command $programName
	} else {
			Write-Host "$programName found. Skipping installation"
	}
}

chocoInstallIfNotFound "git.exe" "git.install"
chocoInstallIfNotFound "python" "python3" ""
chocoInstallIfNotFound "gcc.exe" "mingw" ""
chocoInstallIfNotFound "arm-none-eabi-gcc.exe" "gcc-arm-embedded" ""
chocoInstallIfNotFound "make.exe" "make" ""
chocoInstallIfNotFound "cmake.exe" "cmake" "--version=3.22.1 -y --force --installargs 'ADD_CMAKE_TO_PATH=System'"
chocoInstallIfNotFound "clangd.exe" "llvm" ""
