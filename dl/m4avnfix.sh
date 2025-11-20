# ===== MODULE 1: Khởi động =====
clear
echo "Script chuẩn hoá tên file cho máy nghe nhạc:"
echo "Đang setup..."
sleep 2

# Kiểm tra môi trường Termux (Android)
if [ -n "$PREFIX" ] && [[ "$PREFIX" == *"/data/data/com.termux"* ]]; then
  echo ""
  echo "Cảnh báo: Termux không được hỗ trợ. Script sẽ tiếp tục chạy."
  sleep 2
fi

# Truy cập HOME
cd "$HOME" || { echo "Không thể truy cập \$HOME"; exit 1; }

sleep 2

# ===== MODULE 2: Chọn folder =====
while true; do
  clear
  echo "Bạn đang ở: $(pwd)"
  echo "==================================="

  # Lấy danh sách thư mục con (bỏ .hidden) và cache
  subfolders=()
  while IFS= read -r dir; do
    subfolders+=("$(basename "$dir")")
  done < <(find . -maxdepth 1 -mindepth 1 -type d -not -name '.*' | sort)

  if [ "${#subfolders[@]}" -eq 0 ]; then
    echo "Không còn thư mục con nào."
    echo "-----------------------------------"
    echo "[Enter] chọn thư mục này"
    echo "[~] quay về HOME"
    echo "==================================="
    read -p "Lựa chọn: " choice

    if [ -z "$choice" ]; then
      echo "$(pwd)"
      break
    elif [ "$choice" = "~" ]; then
      cd "$HOME"
    else
      echo "Không hợp lệ!"
      sleep 1
    fi
  else
    i=1
    for folder in "${subfolders[@]}"; do
      printf "%-3s %s\n" "$i" "$folder"
      ((i++))
    done
    echo "-----------------------------------"
    echo "[Enter] chọn thư mục này"
    echo "[~] quay về HOME"
    echo "==================================="
    read -p "Lựa chọn: " choice

    if [ -z "$choice" ]; then
      echo "$(pwd)"
      break
    elif [ "$choice" = "~" ]; then
      cd "$HOME"
    elif [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#subfolders[@]}" ]; then
      cd "${subfolders[$((choice-1))]}"
    else
      echo "Không hợp lệ!"
      sleep 1
    fi
  fi
done

# Lưu folder cuối cùng để module 3 dùng
target_folder="$(pwd)"

# ===== MODULE 3: Rename file .m4a =====
echo "-----------------------------------"
echo "Bắt đầu xử lý file .m4a..."
sleep 2

# Log với timestamp, lưu ở HOME
log_file="$HOME/Rename_log_$(date +%Y%m%d_%H%M%S).txt"
> "$log_file"

shopt -s nullglob
files=(*.m4a)

if [ ${#files[@]} -eq 0 ]; then
  echo "Không có file .m4a nào để xử lý"
  echo "Không có file nào để rename" >> "$log_file"
else
  conflict_count=0
  rename_count=0
  for f in "${files[@]}"; do
    new=$(echo "$f" \
      | sed 's/[àáạảãâầấậẩẫăằắặẳẵ]/a/g' \
      | sed 's/[èéẹẻẽêềếệểễ]/e/g' \
      | sed 's/[ìíịỉĩ]/i/g' \
      | sed 's/[òóọỏõôồốộổỗơờớợởỡ]/o/g' \
      | sed 's/[ùúụủũưừứựửữ]/u/g' \
      | sed 's/[ỳýỵỷỹ]/y/g' \
      | sed 's/đ/d/g' \
      | sed 's/[ÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴ]/A/g' \
      | sed 's/[ÈÉẸẺẼÊỀẾỆỂỄ]/E/g' \
      | sed 's/[ÌÍỊỈĨ]/I/g' \
      | sed 's/[ÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠ]/O/g' \
      | sed 's/[ÙÚỤỦŨƯỪỨỰỬỮ]/U/g' \
      | sed 's/[ỲÝỴỶỸ]/Y/g' \
      | sed 's/Đ/D/g')

    # Nếu tên mới trùng với file khác, thêm hậu tố _1, _2...
    final_name="$new"
    counter=1
    while [ -e "$final_name" ] && [ "$final_name" != "$f" ]; do
      final_name="${new%.*}_$counter.${new##*.}"
      ((counter++))
    done

    if [ "$f" != "$final_name" ]; then
      if mv -n "$f" "$final_name"; then
        echo "Renamed: $f → $final_name"
        echo "Renamed: $f → $final_name" >> "$log_file"
        ((rename_count++))
      else
        echo "Không thể rename: $f"
        echo "Failed: $f → $final_name" >> "$log_file"
        ((conflict_count++))
      fi
    fi
  done

  # Tóm tắt
  echo ""
  echo "-----------------------------------"
  echo "Tóm tắt: $rename_count file được rename, $conflict_count file không rename được."
  echo "Log chi tiết: $log_file"
fi

echo ""
read -p "Nhấn Enter để thoát..."
clear
exit 0
