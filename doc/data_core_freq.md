<!-- data_core_freq.md, a_pinyin/doc/
-->

# Generate data file for `core_freq`

Basic information:

| name           | value                                              |
| :------------- | :------------------------------------------------- |
| core code      | `core_pinyin/core_lib/src/main/kotlin/core_freq/`  |
| package        | `org.sceext.a_pinyin.core_freq`                    |
| core class     | `ACoreFreq`                                        |
| data class     | `ACoreFreqData`                                    |
| json data file | `/sdcard/a_pinyin/core/core_freq.json`             |
| kryo data file | `/sdcard/a_pinyin/core/core_freq.kryo`             |
| android assets | `apk/android/app/src/main/assets/core/TODO` *TODO* |


## Generate raw data file `core_freq.json`

Data file dependencies:

| name                  | description |
| :-------------------- | :---------- |
| `char_sort.json`      | TODO        |
| `char_count.json`     | TODO        |
| `char_to_pinyin.json` | TODO        |

Tools:

| name                | path                  | description |
| :------------------ | :-------------------- | :---------- |
| `pinyin_to_char.py` | `py_tools/pinyin/`    | TODO        |
| `gen_core_freq.py`  | `py_tools/core_freq/` | TODO        |

Commands:

```
# generate pinyin_to_char.json
> python pinyin_to_char.py char_to_pinyin.json char_sort.json pinyin_to_char.json

# generate core_freq.json
> python gen_core_freq.py char_count.json pinyin_to_char.json core_freq.json
```


## Generate `core_freq.kryo`

Tool: `core_pinyin/cli/cli_core_freq/`

```
> java -jar cli_core_freq-all.jar core_freq.json core_freq.kryo
```
