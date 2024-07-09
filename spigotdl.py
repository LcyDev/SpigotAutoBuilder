import yaml, requests, subprocess, os

from src import versions

def load_config(filename: str):
    with open(filename, 'r') as yaml_file:
        return yaml.safe_load(yaml_file)


def get_build_number():
    url = "https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/api/json"
    response = requests.get(url)

    if response.status_code == 200:
        data = response.json()
        return data["number"]
    else:
        print(f"Failed to retrieve build number. HTTP status code: {response.status_code}")
        return None

def download_build_tools():
    build_number = get_build_number()
    if build_number is not None:
        url = f"https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar"
        output_file_path = "BuildTools.jar"
        response = requests.get(url)

        if response.status_code == 200:
            if os.path.exists(output_file_path):
                os.remove(output_file_path)
            with open(output_file_path, 'wb') as file:
                file.write(response.content)
            print(f"File downloaded successfully to {output_file_path}")
        else:
            print(f"Failed to download file. HTTP status code: {response.status_code}")

def build_version(version):
    required_java = get_required_java(version)
    if not config["java"][required_java]:
        print(f"({version}) Java installation not found. {required_java}.")
        return
    cmd = [
        config["java"][required_java],
        *[flag for flag in config["build"]["jvm_flags"]],
        "-jar", "BuildTools.jar",
        "--output-dir", config["output"],
        "--rev", version,
    ]
    if config["build"]["mappings"]:
        cmd.append("--remapped")

    if config["build"]["craftbukkit"]:
        cmd.extend(["--compile", "craftbukkit"])
    if config["build"]["spigot"]:
        cmd.extend(["--compile", "spigot"])

    for flag in config["build"]["flags"]:
        cmd.extend(flag.split(' '))

    try:
        if config["debug"]:
            print(cmd)
        else:
            result = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, check=True)
            print(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"Build failed with return code {e.returncode}:")
        print(e.stderr)

def protocol(value) -> int:
    return int(value.strip('.x').replace('.', ''))


def get_required_java(version):
    if protocol(version) > 117:
        return "JDK17"
    elif protocol(version) == 116:
        return "JDK16"
    elif protocol(version) > 113:
        return "JDK11"
    else:
        return "JDK8"

def main():
    global config
    config = load_config("config.yml")
    download_build_tools()

    for encoded in config["versions"]:
        for v in versions.decodeStringVersion(encoded):
            build_version(v)

if __name__ == "__main__":
    main()